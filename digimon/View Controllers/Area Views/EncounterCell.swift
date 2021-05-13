//
//  EncounterCell.swift
//  digimon
//
//  Created by Emira Hajj on 5/12/21.
//

import UIKit

class EncounterCell: UITableViewCell {

    @IBOutlet weak var minLevelLabel: UILabel!
    
    @IBOutlet weak var minLevelAmt: UILabel!
    @IBOutlet weak var maxLevelLabel: UILabel!
    
    @IBOutlet weak var maxLevelAmt: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    
    @IBOutlet weak var chanceLabel: UILabel!
    
    @IBOutlet weak var method: UILabel!
    @IBOutlet weak var methodLabel: UILabel!
    @IBOutlet weak var chanceAmt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
