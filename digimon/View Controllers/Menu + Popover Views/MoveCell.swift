//
//  MoveCell.swift
//  digimon
//
//  Created by Emira Hajj on 5/1/21.
//

import UIKit

class MoveCell: UITableViewCell {
    
    @IBOutlet weak var moveName: UILabel!
    
    @IBOutlet weak var levelLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
