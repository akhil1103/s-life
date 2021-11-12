//
//  APIUtils.swift
//  S-Computer
//
//  Created by balabalaji on 18/08/21.
//

import Foundation
import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

/// created singleton Alamofire Service class contains get and post methods
class APIUtils: NSObject
{
    static let apiUtilObj = APIUtils()
    
    var currentSessionToken: String = ""
    
    internal var request: Alamofire.DataRequest?
    private var alamoFireManager = Alamofire.SessionManager.default
    internal var offlineProductID = 0
    
    /*
     Making the constructor as private for singleton purpose
     */
    private override init(){
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 25// seconds
        configuration.timeoutIntervalForResource = 25
        self.alamoFireManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    /*
     Cancel the Request's
     */
    internal func cancelRequest() {
        if request != nil {
            request?.cancel()
            request = nil
        } else {
        }
    }
    
    /*
     Making the function as Generic and passing model class object and calling protocol methods for success/Fail response
     */
    internal func makePostResponseObject<T : NSObject>(requestUrl : String, modelType : T.Type,headers :[String : String]?, parameters: [String : AnyObject]?, responseCallBack : IService) where T : Mappable {
        if headers != nil {
            request = self.alamoFireManager.request(requestUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        } else {
            request = self.alamoFireManager.request(requestUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default)
        }
        request!.validate(contentType: ["application/json"])
            .responseObject(completionHandler: { (response: DataResponse<T>) in
                switch response.result{
                case .success:
                    if let postModelObj = response.result.value {
                        responseCallBack.SuccessResponse(postModelObj as! NSArray)
                    }
                    break
                case .failure(let error):
                    responseCallBack.ErrorResponse(error as NSError)
                    break
                }
            })
    }
    
    /*
     Making the function as Generic and passing model class object and calling protocol methods for success/Fail response
     */
    internal func makeGetResponseObject<T : NSObject>(requestUrl : String,headers :[String : String]?, modelType : T.Type,responseCallBack : IService,currencyId:String) where T : Mappable {
        
        if headers != nil {
            request = self.alamoFireManager.request(requestUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
        } else {
            request = self.alamoFireManager.request(requestUrl, method: .get, parameters: nil, encoding: JSONEncoding.default)
        }
        request!.validate(contentType: ["application/json"])
            .responseObject(completionHandler: { (response: DataResponse<T>) in
                switch response.result{
                case .success:
                    if let getModelObj = response.result.value {
                        responseCallBack.SuccessResponse(getModelObj,currencyId)
                    }
                    break
                case .failure(let error):
                    responseCallBack.ErrorResponse(error as NSError)
                    break
                }
            })
    }
    
    /*
     Making the function as Generic and passing model class object and calling protocol methods for success/Fail response
     */
    internal func makeGetResponseArray<T : NSObject>(requestUrl : String,headers :[String : String]?, modelType : T.Type,responseCallBack : IService) where T : Mappable {
        
        if headers != nil {
            request = self.alamoFireManager.request(requestUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
        } else {
            request = self.alamoFireManager.request(requestUrl, method: .get, parameters: nil, encoding: JSONEncoding.default)
        }
        request!.validate(contentType: ["application/json"])
            .responseArray(completionHandler: { (response: DataResponse<[T]>) in
                switch response.result{
                case .success:
                    if let getModelObj = response.result.value {
                        responseCallBack.SuccessResponse(getModelObj as NSArray)
                    }
                    break
                case .failure(let error):
                    responseCallBack.ErrorResponse(error as NSError)
                    break
                }
            })
    }
    
    internal func callApi(requestUrl : String, method: HTTPMethod, parameters: [String : AnyObject]?, success:@escaping (NSObject, Data) -> (), failure: @escaping(NSError) -> ()) {
        var requestApi: Alamofire.DataRequest?
        let headers = ["Authorization" : APIUtils.apiUtilObj.currentSessionToken]
        requestApi = self.alamoFireManager.request(requestUrl, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        requestApi!.validate(contentType: ["application/json"]).responseJSON(completionHandler: { (response: DataResponse) in
            switch response.result{
            case .success:
                if let getModelObj = response.result.value as? NSObject, let responseData = response.data{
                    success(getModelObj, responseData)
                }
                break
            case .failure(let error):
                failure(error as NSError)
                break
            }
        })
    }
}
