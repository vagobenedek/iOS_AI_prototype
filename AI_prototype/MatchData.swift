//
//  MatchData.swift
//  AI_prototype
//
//  Created by Vágó Benedek on 2021. 04. 28..
//

import Foundation

class MatchData: Decodable {
    var localTeam: Team
    var visitorTeam: Team
    let id: Int
    let championship: String
    let country: String
    var evaluationData: StrategyData?
}

class Team: Decodable {
    let name: String
    let logo: String
}

struct StrategyData: Decodable{
    let money: String?
    let result: Bool?
    let id: Int
    let outcome: Int
    let bet: [Double]
}

struct League: Decodable {
    let id: Int
    let name: String
    let country: String
    let type: String
    let season: Int
}

struct ApplyData: Encodable {
    var match_ids: [Int]
    var market: String
    var strategy: String
}

struct SeasonLeagues: Decodable {
    let country: String
    let leagues: [String]
}

struct SeasonData: Encodable {
    var market: String
    var strategy: String
    var country: String
    var league: String
}

struct Prediction: Decodable {
    let Home: Double
    let Draw: Double
    let Away: Double
}


