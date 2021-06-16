//
//  ApplyFormViewController.swift
//  AI_prototype
//
//  Created by Vágó Benedek on 2021. 04. 29..
//

import UIKit

class ApplyFormViewController: UIViewController {
    @IBOutlet weak var picker: UIPickerView!
    
    var markets: [String] = []
    var strategies: [String] = []
    var chosenMarket: String = ""
    var chosenStrategy: String = ""

    var matchManager: MatchManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Hi from form!")
        matchManager?.dataDelegate = self
        matchManager?.getStrategies()
        matchManager?.getMarkets()
        picker.delegate = self
        picker.dataSource = self
    }
    
    @IBAction func applyStrategy(_ sender: Any) {
        var match_ids: [Int] = []
        for match in MatchesToTest.shared.matches {
            match_ids.append(match.id)
        }
        matchManager?.applyStrategy(strategy: chosenStrategy, market: chosenMarket, match_ids: match_ids)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func testStrategy(_ sender: Any) {
        var match_ids: [Int] = []
        for match in MatchesToTest.shared.matches {
            match_ids.append(match.id)
        }
        matchManager?.testStrategy(strategy: chosenStrategy, market: chosenMarket, match_ids: match_ids)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ApplyFormViewController: DataManagerDelegate {
    
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

extension ApplyFormViewController: UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return markets.count
        }
        else if component == 1 {
            return strategies.count
        }
        return 0
    }
    
    
}

extension ApplyFormViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return markets[row]
        }
        else if component == 1 {
            return strategies[row]
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
    }
}
