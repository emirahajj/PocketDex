//
//  HeaderCell.swift
//  digimon
//
//  Created by Emira Hajj on 5/15/21.
//

import UIKit

class HeaderCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var pkmnImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor(red: 0.73, green: 0.59, blue: 0.95, alpha: 1.00)

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
