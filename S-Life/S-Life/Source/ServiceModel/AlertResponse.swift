//
//  AlertResponse.swift
//  S-Life
//
//  Created by Akhil Mittal on 25/02/22.
//

import Foundation

// MARK: - AlertResponseElement
struct Alert: Codable {
    let title, desc: String?
    let location: Location?
    let category: Category?
    let id: String?
    let version: Int?
    let date: String?

    enum CodingKeys: String, CodingKey {
        case title
        case desc = "description"
        case id = "_id"
        case version = "__v"
        case location, category, date
    }
}

// MARK: - Location
struct Location: Codable {
    let lat, long: Double?
}

enum Category: Int, Codable {
    case cat = 0, cat1
    
    func getAlertCatName() -> String {
        switch self {
        case .cat:
            return "Others"
        case .cat1:
            return "Natural Calamity"
        }
    }
}

typealias AlertResponse = [Alert]
