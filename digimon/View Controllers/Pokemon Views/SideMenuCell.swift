//
//  SideMenuCell.swift
//  digimon
//
//  Created by Emira Hajj on 5/5/21.
//

import UIKit

class SideMenuCell: UITableViewCell {
    
    var labelText = UILabel()

    @IBOutlet weak var versionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
