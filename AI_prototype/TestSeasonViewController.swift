//
//  TestSeasonViewController.swift
//  AI_prototype
//
//  Created by Vágó Benedek on 2021. 05. 01..
//

import UIKit

class TestSeasonViewController: UIViewController, SeasonDelegate {
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var profitLabel: UILabel!
    
    var matchManager: MatchManager = MatchManager()
    var leagues: [SeasonLeagues] = []
    var chosenLeague = 0
    var chosenLeagueCountry: String = ""
    var choseLeagueName: String = ""
    var markets: [String] = []
    var strategies: [String] = []
    var chosenMarket: String = ""
    var chosenStrategy: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        matchManager.seasonDelegate = self
        matchManager.dataDelegate = self
        matchManager.getMarkets()
        matchManager.getStrategies()
        matchManager.getLeaguesForSeason()
        picker.dataSource = self
        picker.delegate = self
    }
    
    @IBAction func testSeason(_ sender: Any) {
        matchManager.testStrategyOnSeason(strategy: self.chosenStrategy, market: self.chosenMarket, country: self.chosenLeagueCountry, league: self.choseLeagueName)
    }
    
    func setLeagues(leagues: [SeasonLeagues]) {
        self.leagues = leagues
    }
    
    func refreshDataWithStrategies(data: [StrategyData]) {
        let money = Double(data[data.count-1].money!)
        DispatchQueue.main.async {
            self.profitLabel.text = "Profit: \(money! * 100 - 100)%"
        }
    }
}

extension TestSeasonViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return markets.count
        }
        else if component == 1 {
            return strategies.count
        }
        else if component == 2 {
            return leagues.count
        }
        else if component == 3 {
            return leagues.count == 0 ? 0 : leagues[chosenLeague].leagues.count
        }
        return 0
    }
}

extension TestSeasonViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return markets[row]
        }
        else if component == 1 {
            return strategies[row]
        }
        else if component == 2 {
            return leagues[row].country
        }
        else if component == 3 {
            return leagues[chosenLeague].leagues[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            self.chosenMarket = markets[row]
        }
        else if component == 1 {
            self.chosenStrategy = strategies[row]
        }
        else if component == 2 {
            self.chosenLeague = row
            self.choseLeagueName = leagues[row].leagues[0]
            self.chosenLeagueCountry = leagues[row].country
        }
        else if component == 3 {
            self.choseLeagueName = leagues[chosenLeague].leagues[row]
        }
        DispatchQueue.main.async {
            self.picker.reloadAllComponents()
        }
    }
}

extension TestSeasonViewController: DataManagerDelegate {
    
    func setMarkets(markets: [String]) {
        self.markets = markets
        self.chosenMarket = markets[0]
        DispatchQueue.main.async {
            self.picker.reloadAllComponents()
        }
    }
    
    func setStrategies(strategies: [String]) {
        self.strategies = strategies
        self.chosenStrategy = strategies[0]
        DispatchQueue.main.async {
            self.picker.reloadAllComponents()
        }
    }
    
}
