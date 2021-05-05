//
//  SideMenuCell.swift
//  digimon
//
//  Created by Emira Hajj on 5/5/21.
//

import UIKit

class SideMenuCell: UITableViewCell {
    
    var labelText = UILabel() //IB outlets are not connected when you instantiate a VC hence, we need the if let


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
