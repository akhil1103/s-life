//
//  IService.swift
//  S-Life
//
//  Created by Akhil Mittal on 18/01/22.
//

import Foundation
protocol IService
{
    func SuccessResponse(_ json :NSArray)
    func SuccessResponse(_ json :NSObject, _ currecyId : String)
    func ErrorResponse(_ error : NSError)
}
