//
//  MapViewController.swift
//  S-Life
//
//  Created by Akhil Mittal on 25/02/22.
//

import UIKit
import Mapbox

@objc(OfflinePackExample_Swift)

class MapViewController: BaseViewController, MGLMapViewDelegate {
    @IBOutlet weak var topSpaceToHeaderImageCosntraint: NSLayoutConstraint!
    @IBOutlet weak var topBarHight: NSLayoutConstraint!
    @IBOutlet weak var mapParentView: UIView!
    private var progressView: UIProgressView!
    private var mapView: MGLMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        topBarHight.constant = UIDevice.current.hasNotch ? 110 : 65
        topSpaceToHeaderImageCosntraint.constant = UIDevice.current.hasNotch ? 0 : 0
        
        mapView = MGLMapView(frame: mapParentView.bounds, styleURL: NSURL(string: "mapbox://styles/amittal776/ckuc7xe1s4nst18ldjbwuzzg8") as URL?)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.tintColor = .gray
        mapView.delegate = self
        mapParentView.addSubview(mapView)

        mapView.setCenter(CLLocationCoordinate2D(latitude: 17.425641, longitude: 78.415858),
                          zoomLevel: 10, animated: true)

        // Setup offline pack notification handlers.
        NotificationCenter.default.addObserver(self, selector: #selector(offlinePackProgressDidChange), name: NSNotification.Name.MGLOfflinePackProgressChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(offlinePackDidReceiveError), name: NSNotification.Name.MGLOfflinePackError, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(offlinePackDidReceiveMaximumAllowedMapboxTiles), name: NSNotification.Name.MGLOfflinePackMaximumMapboxTilesReached, object: nil)
        
    }
    
    func getEvacuationCenterInfo() -> [MGLPointAnnotation]{
        var evacuationCentersPoints = [MGLPointAnnotation]()
        let point = MGLPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude:17.345042, longitude:78.448817)
        point.title = "Evacuation Center 004"
        point.subtitle = "An evacuation center to provide all necessary hospitality in case of emergency"
        evacuationCentersPoints.append(point)
        
        let point1 = MGLPointAnnotation()
        point1.coordinate = CLLocationCoordinate2D(latitude:17.375189, longitude:78.428217)
        point1.title = "Evacuation Center 006"
        point1.subtitle = "Evacuation center 006. Everyone's health is important"
        evacuationCentersPoints.append(point1)
            
        let point2 = MGLPointAnnotation()
        point2.coordinate = CLLocationCoordinate2D(latitude:17.425641, longitude:78.415858)
        point2.title = "Evacuation Center 001"
        point2.subtitle = "An evacuation center to provide all necessary helps in emergency"
        evacuationCentersPoints.append(point2)
            
        let point3 = MGLPointAnnotation()
        point3.coordinate = CLLocationCoordinate2D(latitude:17.483938, longitude:78.360239)
        point3.title = "Evacuation Center 002"
        point3.subtitle = "Rudraram evacuation center, having all facility to provide necessary hospitality for all peoples"
        evacuationCentersPoints.append(point3)
            
        let point4 = MGLPointAnnotation()
        point4.coordinate = CLLocationCoordinate2D(latitude:17.504500, longitude:78.335857)
        point4.title = "Evacuation Center 003"
        point4.subtitle = "Evacuation center in Chandanagar powered and facilitated by authorised organisation"
        evacuationCentersPoints.append(point4)
            
        let point5 = MGLPointAnnotation()
        point5.coordinate = CLLocationCoordinate2D(latitude:17.505193, longitude:78.291273)
        point5.title = "Evacuation Center 005"
        point5.subtitle = "A new evacuation center, in the middle of the city to provide all necessary needs to all people"
        evacuationCentersPoints.append(point5)
            
        return evacuationCentersPoints
    }
        
    func mapView( _ mapView: MGLMapView, imageFor annotation: MGLAnnotation ) -> MGLAnnotationImage? {
        var annotationImage : MGLAnnotationImage? = nil
        if let image = UIImage(named: "location"), let resuseId = annotation.title {
                  annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: resuseId ?? "")
            return annotationImage
        }
        return nil
    }

    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        // Start downloading tiles and resources for z13-14.
        
        startOfflinePackDownload()
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        let points = getEvacuationCenterInfo()
        for point in points {
            mapView.addAnnotation(point)
        }
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

    @objc func offlinePackDidReceiveMaximumAllowedMapboxTiles(notification: NSNotification){
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
