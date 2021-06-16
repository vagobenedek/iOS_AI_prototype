//
//  MatchManager.swift
//  AI_prototype
//
//  Created by Vágó Benedek on 2021. 04. 28..
//

import Foundation

protocol MatchManagerDelegate {
    func didUpdateMatches(_ matchManager: MatchManager, matches: [MatchData])
}

protocol DataManagerDelegate {
    func setMarkets(markets: [String])
    func setStrategies(strategies: [String])
}

protocol ApplyDelegate {
    func refreshDataWithStrategies(data: [StrategyData])
    func refreshDataWithPredictions(data: [Prediction])
}

protocol LeagueDelegate {
    func setLeagues(leagues: [League])
}
protocol SeasonDelegate {
    func setLeagues(leagues: [SeasonLeagues])
    func refreshDataWithStrategies(data: [StrategyData])
}

class MatchManager {
        
    var delegate: MatchManagerDelegate?
    var applyDelegate: ApplyDelegate?
    var dataDelegate: DataManagerDelegate?
    var leagueDelegate: LeagueDelegate?
    var seasonDelegate: SeasonDelegate?
    
    func getMatches(date: String){
        if let url = URL(string: "http://localhost:3000/fixturesbydate") {
            let session = URLSession(configuration: .default)
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let data = ["date": date]
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try! JSONSerialization.data(withJSONObject: data, options: [])
            
            let task = session.dataTask(with: request){ (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData=data {
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode([MatchData].self, from: safeData)
                        self.delegate?.didUpdateMatches(self, matches: decodedData)
                    } catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }
    }
    
    func getMarkets() {
        if let url = URL(string: "http://localhost:3000/markets"){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url){ (data, response, error)  in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData=data {
                    let decoder = JSONDecoder()
                    do {
                        let markets = try decoder.decode([String].self, from: safeData)
                        self.dataDelegate?.setMarkets(markets: markets)
                    } catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }
    }
    
    func getStrategies() {
        if let url = URL(string: "http://localhost:3000/strategies"){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url){ (data, response, error)  in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData=data {
                    let decoder = JSONDecoder()
                    do {
                        let strategies = try decoder.decode([String].self, from: safeData)
                        print(strategies)
                        self.dataDelegate?.setStrategies(strategies: strategies)
                    } catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }
    }
    
    func getLeagues(){
        if let url = URL(string: "http://localhost:3000/leagues"){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url){ (data, response, error)  in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData=data {
                    let decoder = JSONDecoder()
                    do {
                        let leagues = try decoder.decode([League].self, from: safeData)
                        self.leagueDelegate?.setLeagues(leagues: leagues)
                    } catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }
    }
    
    func getLeaguesForSeason(){
        if let url = URL(string: "http://localhost:3000/leaguesforseason"){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url){ (data, response, error)  in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData=data {
                    let decoder = JSONDecoder()
                    do {
                        let leagues = try decoder.decode([SeasonLeagues].self, from: safeData)
                        self.seasonDelegate?.setLeagues(leagues: leagues)
                    } catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }
    }
    
    func getPredictions(match_ids: [Int]){
        let data = ApplyData(match_ids: match_ids, market: "full_time", strategy: "")
        if let url = URL(string: "http://localhost:3000/getprediction"){
            let sessionConfig = URLSessionConfiguration.default
            sessionConfig.timeoutIntervalForRequest = 230.0
            sessionConfig.timeoutIntervalForResource = 260.0
            
            let session = URLSession(configuration: sessionConfig)
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try! JSONEncoder().encode(data)
            
            let task = session.dataTask(with: request){ (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData=data {
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode([Prediction].self, from: safeData)
                        print("Hey, about to call applyDelegate!")
                        self.applyDelegate?.refreshDataWithPredictions(data: decodedData)
                    } catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }
    }
    
    func applyStrategy(strategy: String, market: String, match_ids: [Int]){
        let data = ApplyData(match_ids: match_ids, market: market, strategy: strategy)
        if let url = URL(string: "http://localhost:3000/applystrategy"){
            let sessionConfig = URLSessionConfiguration.default
            sessionConfig.timeoutIntervalForRequest = 230.0
            sessionConfig.timeoutIntervalForResource = 260.0
            
            let session = URLSession(configuration: sessionConfig)
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try! JSONEncoder().encode(data)
            
            let task = session.dataTask(with: request){ (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData=data {
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode([StrategyData].self, from: safeData)
                        print("Hey, about to call applyDelegate!")
                        self.applyDelegate?.refreshDataWithStrategies(data: decodedData)
                    } catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }
    }
    
    func testStrategy(strategy: String, market: String, match_ids: [Int]){
        let data = ApplyData(match_ids: match_ids, market: market, strategy: strategy)
        if let url = URL(string: "http://localhost:3000/teststrategyfixtures"){
            let sessionConfig = URLSessionConfiguration.default
            sessionConfig.timeoutIntervalForRequest = 230.0
            sessionConfig.timeoutIntervalForResource = 260.0
            
            let session = URLSession(configuration: sessionConfig)
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try! JSONEncoder().encode(data)
            
            let task = session.dataTask(with: request){ (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData=data {
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode([StrategyData].self, from: safeData)
                        print("Hey, about to call applyDelegate!")
                        self.applyDelegate?.refreshDataWithStrategies(data: decodedData)
                    } catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }
    }
    
    
    func testStrategyOnSeason(strategy: String, market: String, country: String, league: String){
        if let url = URL(string: "http://localhost:3000/teststrategyseason"){
            let session = URLSession(configuration: .default)
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let data = SeasonData(market: market, strategy: strategy, country: country, league: league)
            print("market: \(market), strategy: \(strategy), country: \(country), league: \(league)")
            request.httpBody = try! JSONEncoder().encode(data)
            
            let task = session.dataTask(with: request){ (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData=data {
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode([StrategyData].self, from: safeData)
                        self.seasonDelegate?.refreshDataWithStrategies(data: decodedData)
                    } catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }
    }

}
