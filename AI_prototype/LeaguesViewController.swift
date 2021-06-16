//
//  LeaguesViewController.swift
//  AI_prototype
//
//  Created by Vágó Benedek on 2021. 04. 30..
//

import UIKit

class LeaguesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, LeagueDelegate {
    
    func setLeagues(leagues: [League]) {
        for league in leagues {
            self.leagues.append("\(league.country) - \(league.name)")
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    var leagues: [String] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leagues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "league", for: indexPath)
        cell.textLabel?.text = leagues[indexPath.row]
        return cell
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var matchManager = MatchManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        matchManager.leagueDelegate = self
        matchManager.getLeagues()
    }
}
