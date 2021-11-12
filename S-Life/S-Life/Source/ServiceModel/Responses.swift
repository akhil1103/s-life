//
//  Responses.swift
//  S-Life
//
//  Created by balabalaji on 18/08/21.

import Foundation

class BaseResponse {
    static func parse(response:[String: Any], result:(_ code: String, _ message: String, _ item: [String : Any]) -> ()) {
        if (response["errors"] != nil) {
            if let errorsObj = response["errors"] as? [[String: Any]] {
                if errorsObj.count > 0 {
                    let errorObj = errorsObj[0]
                    guard let msg = errorObj["msg"] as? String else {
                        result(ResponseCode.error.rawValue, CommonStrings.errorMessage , [:])
                        return
                    }
                    result(ResponseCode.error.rawValue, msg, [:])
                } else {
                    result(ResponseCode.error.rawValue, CommonStrings.errorMessage, [:])
                }
            } else {
                result(ResponseCode.error.rawValue, CommonStrings.errorMessage , [:])
            }
        } else {
            result(ResponseCode.success.rawValue, "", response)
        }
    }
}
