//
//  MatchesToTest.swift
//  AI_prototype
//
//  Created by Vágó Benedek on 2021. 04. 29..
//

import Foundation

class MatchesToTest {
    var matches: [MatchData]
    static let shared = MatchesToTest()
    
    private init(){
        self.matches = []
    }
    
    func appendMatch(match: MatchData){
        matches.append(match)
    }
    
    func removeMatch(match: MatchData){
        matches.removeAll { (matchData) -> Bool in
            matchData.id == match.id
        }
    }
}
