//
//  Team.swift
//  FanChatApp
//
//  Created by max on 17.03.2022.
//

import Foundation

struct JSONResponse: Codable {
    let status: Bool
    let data: DataClass
}

struct DataClass: Codable {
    let name, abbreviation, seasonDisplay: String
    let season: Int
    let standings: [Standing]
}

struct Standing: Codable {
    let team: Team
    let note: Note?
    let stats: [Stat]
}

// MARK: - Note
struct Note: Codable {
    let color, description: String
    let rank: Int
}

// MARK: - Stat
struct Stat: Codable {
//    let name: Name
//    let displayName: Description
    let shortDisplayName: String
//    let description: Description
    let abbreviation, type: String
    let value: Int?
    let displayValue: String
    let id, summary: String?

}
// MARK: - Team
struct Team: Codable {
    let id, uid, location, name: String
    let abbreviation, displayName, shortDisplayName: String
    let isActive: Bool
    let logos: [Logo]
}

// MARK: - Logo
struct Logo: Codable {
    let href: String
    let width, height: Int
    let alt: String
    let rel: [String]
    let lastUpdated: String
}


