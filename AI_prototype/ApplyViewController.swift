//
//  ApplyViewController.swift
//  AI_prototype
//
//  Created by Vágó Benedek on 2021. 04. 28..
//

import UIKit

class ApplyViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var matches: [MatchData] = []
    var matchManager = MatchManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Heey from Apply!")
        matchManager.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "AltMatchCell", bundle: nil), forCellReuseIdentifier: "AltMatchCell")
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let selectedDate = dateFormatter.string(from: date)
        matchManager.getMatches(date: selectedDate)
        
        
        datePicker.datePickerMode = .date
    }
    
    @IBAction func datePicked(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let selectedDate = dateFormatter.string(from: sender.date)
        matchManager.getMatches(date: selectedDate)
    }
}

extension ApplyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AltMatchCell", for: indexPath) as! AltMatchCell
        cell.localTeam.text = matches[indexPath.row].localTeam.name
        cell.localLogo.load(url: URL(string: matches[indexPath.row].localTeam.logo)!)
        cell.visitorTeam.text = matches[indexPath.row].visitorTeam.name
        cell.visitorLogo.load(url: URL(string: matches[indexPath.row].visitorTeam.logo)!)
        return cell
    }
    
}

extension ApplyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MatchesToTest.shared.appendMatch(match: matches[indexPath.row])
        print(matches[indexPath.row].id)
    }
}

extension ApplyViewController: MatchManagerDelegate {
    func didUpdateMatches(_  matchManager: MatchManager, matches: [MatchData]) {
        self.matches.removeAll()
        for match in matches {
            self.matches.append(match)
        }
        self.matches.sort { (m1, m2) -> Bool in
            m1.country > m2.country
        }
        print(matches.count)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

