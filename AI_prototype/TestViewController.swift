//
//  TestViewController.swift
//  AI_prototype
//
//  Created by Vágó Benedek on 2021. 04. 28..
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var matchManager = MatchManager()
    var allMoney = 13000.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        matchManager.applyDelegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "AltMatchCell", bundle: nil), forCellReuseIdentifier: "AltMatchCell")
    }
    
    @IBAction func applyStrategy(_ sender: UIBarButtonItem) {
        self.allMoney = 10000.0
        self.performSegue(withIdentifier: "applyStrategy", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "applyStrategy"{
            let destination = segue.destination as! ApplyFormViewController
            destination.matchManager = self.matchManager
        }
    }
    @IBAction func determineProbabilities(_ sender: UIBarButtonItem) {
        var match_ids: [Int] = []
        for match in MatchesToTest.shared.matches {
            match_ids.append(match.id)
        }
        self.allMoney = 1.0
        matchManager.getPredictions(match_ids: match_ids)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension TestViewController: ApplyDelegate {
    func refreshDataWithPredictions(data: [Prediction]) {
        var strategyData: [StrategyData] = []
        for (index, prediction) in data.enumerated() {
            strategyData.append(StrategyData( money: nil, result: nil, id: MatchesToTest.shared.matches[index].id, outcome: -1, bet: [prediction.Home, prediction.Draw, prediction.Away]))
        }
        self.refreshDataWithStrategies(data: strategyData)
    }
    
    func refreshDataWithStrategies(data: [StrategyData]) {
        for match in MatchesToTest.shared.matches {
            let strategyData = data.first { (strategyData) -> Bool in
                return strategyData.id == match.id
            }
            
            match.evaluationData = strategyData
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension TestViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MatchesToTest.shared.matches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AltMatchCell", for: indexPath) as! AltMatchCell
        cell.localTeam.text = MatchesToTest.shared.matches[indexPath.row].localTeam.name
        cell.localLogo.load(url: URL(string: MatchesToTest.shared.matches[indexPath.row].localTeam.logo)!)
        cell.visitorTeam.text = MatchesToTest.shared.matches[indexPath.row].visitorTeam.name
        cell.visitorLogo.load(url: URL(string: MatchesToTest.shared.matches[indexPath.row].visitorTeam.logo)!)
        cell.money.text = ""
        cell.homeMoney.text = ""
        cell.awayMoney.text = ""
        cell.drawMoney.text = ""
        cell.homeMoney.font = UIFont.systemFont(ofSize: 13.0)
        cell.awayMoney.font = UIFont.systemFont(ofSize: 13.0)
        cell.drawMoney.font = UIFont.systemFont(ofSize: 13.0)
        if let strategyData = MatchesToTest.shared.matches[indexPath.row].evaluationData {
            cell.homeMoney.text = String(format: "%.2f", strategyData.bet[0]*self.allMoney)
            cell.drawMoney.text = String(format: "%.2f", strategyData.bet[1]*self.allMoney)
            cell.awayMoney.text = String(format: "%.2f", strategyData.bet[2]*self.allMoney)
            if strategyData.outcome == 0 {
                cell.homeMoney.font = UIFont.boldSystemFont(ofSize: 13.0)
            }
            else if strategyData.outcome == 1 {
                cell.drawMoney.font = UIFont.boldSystemFont(ofSize: 13.0)
            }
            else if strategyData.outcome == 2 {
                cell.awayMoney.font = UIFont.boldSystemFont(ofSize: 13.0)
                
            }
            if let money = strategyData.money {
                cell.money.text = money
                if strategyData.outcome == 0 {
                    cell.homeMoney.textColor = strategyData.result! ? UIColor.systemGreen : UIColor.systemRed
                }
                else if strategyData.outcome == 1 {
                    cell.drawMoney.textColor = strategyData.result! ? UIColor.systemGreen : UIColor.systemRed
                }
                else if strategyData.outcome == 2 {
                    cell.awayMoney.textColor = strategyData.result! ? UIColor.systemGreen : UIColor.systemRed
                }
            }
        }
        return cell
    }
}

extension TestViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MatchesToTest.shared.removeMatch(match: MatchesToTest.shared.matches[indexPath.row])
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
