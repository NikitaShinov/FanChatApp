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

//enum Description: String, Codable {
//    case draws = "Draws"
//    case gamesPlayed = "Games Played"
//    case goalDifference = "Goal Difference"
//    case goalsAgainst = "Goals Against"
//    case goalsFor = "Goals For"
//    case losses = "Losses"
//    case overall = "Overall"
//    case overallRecord = "Overall Record"
//    case pointDeductions = "Point Deductions"
//    case points = "Points"
//    case pointsPerGame = "Points Per Game"
//    case rank = "Rank"
//    case rankChange = "Rank Change"
//    case teamSCurrentWinLossRecord = "Team's current Win-Loss record"
//    case wins = "Wins"
//}



