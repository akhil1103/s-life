//
//  IService.swift
//  S-Life
//
//  Created by balabalaji on 18/08/21.
//

import Foundation
protocol IService
{
    func SuccessResponse(_ json :NSArray)
    func SuccessResponse(_ json :NSObject, _ currecyId : String)
    func ErrorResponse(_ error : NSError)
}
