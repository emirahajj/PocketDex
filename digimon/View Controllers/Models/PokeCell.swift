//
//  DigiCell.swift
//  digimon
//
//  Created by Emira Hajj on 2/4/21.
//

import UIKit

class PokeCell: UITableViewCell {
    
    @IBOutlet weak var digiPic: UIImageView!
    @IBOutlet weak var digiName: UILabel!
    @IBOutlet weak var digiLevel: UILabel!
    var APIstring = String()
    var myPic : String!
    var properName: String!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
