//
//  NearestEvacuationVC.swift
//  S-Life
//
//  Created by balabalaji gowd yelagana on 25/09/21.
//

import UIKit
import Mapbox

class NearestEvacuationVC: UIViewController, MGLMapViewDelegate {
    
    @IBOutlet weak var topBarHight: NSLayoutConstraint!
    @IBOutlet weak var mapParentView: UIView!
    var progressView: UIProgressView!
    var mapView: MGLMapView!
    var alert: SLifeAlert?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        topBarHight.constant = UIDevice.current.hasNotch ? 110 : 65
        
        mapView = MGLMapView(frame: mapParentView.bounds, styleURL: NSURL(string: "mapbox://styles/amittal776/ckrn7n8014gq917mshri41l56") as URL?)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.tintColor = .gray
        mapView.delegate = self
        mapParentView.addSubview(mapView)
        
        mapView.setCenter(CLLocationCoordinate2D(latitude: alert?.lat?.doubleValue ?? 0.0, longitude: alert?.long?.doubleValue ?? 0.0),
                          zoomLevel: 9, animated: false)

        // Setup offline pack notification handlers.
        NotificationCenter.default.addObserver(self, selector: #selector(offlinePackProgressDidChange), name: NSNotification.Name.MGLOfflinePackProgressChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(offlinePackDidReceiveError), name: NSNotification.Name.MGLOfflinePackError, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(offlinePackDidReceiveMaximumAllowedMapboxTiles), name: NSNotification.Name.MGLOfflinePackMaximumMapboxTilesReached, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Nearest Evacuation"
        self.navigationController?.navigationBar.topItem?.title = ""
    }

    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        // Start downloading tiles and resources for z13-14.
        
        startOfflinePackDownload()
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        let point = MGLPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude: alert?.lat?.doubleValue ?? 0.0, longitude: alert?.long?.doubleValue ?? 0.0)
        point.title = alert?.title ?? ""
        mapView.addAnnotation(point)
    }
    
    func mapView( _ mapView: MGLMapView, imageFor annotation: MGLAnnotation ) -> MGLAnnotationImage? {
      var annotationImage : MGLAnnotationImage? = nil
        if let image = UIImage(named: "location"), let resuseId = annotation.title {
            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: resuseId ?? "")
            return annotationImage
        }
        return nil
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        // When leaving this view controller, suspend offline downloads.
        guard let packs = MGLOfflineStorage.shared.packs else { return }
        for pack in packs {
            if let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String] {
                print("Suspending download of offline pack: “\(userInfo["name"] ?? "unknown")”")
            }
            pack.suspend()
        }
    }

    func startOfflinePackDownload() {
        // Create a region that includes the current viewport and any tiles needed to view it when zoomed further in.
        // Because tile count grows exponentially with the maximum zoom level, you should be conservative with your `toZoomLevel` setting.
        let region = MGLTilePyramidOfflineRegion(styleURL: mapView.styleURL, bounds: mapView.visibleCoordinateBounds, fromZoomLevel: mapView.zoomLevel, toZoomLevel: 10)

        // Store some data for identification purposes alongside the downloaded resources.
        let userInfo = ["name": "My Offline Pack"]
        let context = NSKeyedArchiver.archivedData(withRootObject: userInfo)

        // Create and register an offline pack with the shared offline storage object.

        MGLOfflineStorage.shared.addPack(for: region, withContext: context) { (pack, error) in
            guard error == nil else {
                // The pack couldn’t be created for some reason.
                print("Error: \(error?.localizedDescription ?? "unknown error")")
                return
            }

            // Start downloading.
            pack!.resume()
        }

    }

    // MARK: - MGLOfflinePack notification handlers

    @objc func offlinePackProgressDidChange(notification: NSNotification) {
        // Get the offline pack this notification is regarding,
        // and the associated user info for the pack; in this case, `name = My Offline Pack`
        if let pack = notification.object as? MGLOfflinePack,
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String] {
            let progress = pack.progress
            // or notification.userInfo![MGLOfflinePackProgressUserInfoKey]!.MGLOfflinePackProgressValue
            let completedResources = progress.countOfResourcesCompleted
            let expectedResources = progress.countOfResourcesExpected

            // Calculate current progress percentage.
            let progressPercentage = Float(completedResources) / Float(expectedResources)

            // Setup the progress bar.
            if progressView == nil {
                progressView = UIProgressView(progressViewStyle: .default)
                let frame = view.bounds.size
                progressView.frame = CGRect(x: frame.width / 4, y: frame.height * 0.75, width: frame.width / 2, height: 10)
                view.addSubview(progressView)
            }
            print("\(progressPercentage)")
            progressView.progress = progressPercentage

            // If this pack has finished, print its size and resource count.
            if completedResources == expectedResources {
                let byteCount = ByteCountFormatter.string(fromByteCount: Int64(pack.progress.countOfBytesCompleted), countStyle: ByteCountFormatter.CountStyle.memory)
                progressView.isHidden = true
                print("Offline pack “\(userInfo["name"] ?? "unknown")” completed: \(byteCount), \(completedResources) resources")
            } else {
                // Otherwise, print download/verification progress.
                print("Offline pack “\(userInfo["name"] ?? "unknown")” has \(completedResources) of \(expectedResources) resources — \(String(format: "%.2f", progressPercentage * 100))%.")
            }
        }
    }

    @objc func offlinePackDidReceiveError(notification: NSNotification) {
        if let pack = notification.object as? MGLOfflinePack,
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String],
            let error = notification.userInfo?[MGLOfflinePackUserInfoKey.error] as? NSError {
            print("Offline pack “\(userInfo["name"] ?? "unknown")” received error: \(error.localizedFailureReason ?? "unknown error")")
        }
    }

    @objc func offlinePackDidReceiveMaximumAllowedMapboxTiles(notification: NSNotification) {
        if let pack = notification.object as? MGLOfflinePack,
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String],
            let maximumCount = (notification.userInfo?[MGLOfflinePackUserInfoKey.maximumCount] as AnyObject).uint64Value {
            print("Offline pack “\(userInfo["name"] ?? "unknown")” reached limit of \(maximumCount) tiles.")
        }
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
    // Always allow callouts to popup when annotations are tapped.
        return true
    }

}
