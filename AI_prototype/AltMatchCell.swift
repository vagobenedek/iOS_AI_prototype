//
//  AltMatchCell.swift
//  AI_prototype
//
//  Created by Vágó Benedek on 2021. 05. 10..
//

import UIKit

class AltMatchCell: UITableViewCell {
    @IBOutlet weak var localLogo: UIImageView!
    @IBOutlet weak var localTeam: UILabel!
    @IBOutlet weak var visitorLogo: UIImageView!
    @IBOutlet weak var visitorTeam: UILabel!
    
    @IBOutlet weak var money: UILabel!
    
    @IBOutlet weak var homeMoney: UILabel!
    @IBOutlet weak var drawMoney: UILabel!
    @IBOutlet weak var awayMoney: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
