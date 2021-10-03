//
//  AlertResponse.swift
//  S-Life
//
//  Created by balabalaji gowd yelagana on 25/09/21.
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
            return "Disaster"
        case .cat1:
            return "Natural Calamity"
        }
    }
}

typealias AlertResponse = [Alert]
