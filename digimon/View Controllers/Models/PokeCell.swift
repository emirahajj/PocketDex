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
        digiPic.layer.shadowColor = UIColor.darkGray.cgColor
        digiPic.layer.shadowOpacity = 1
        digiPic.layer.shadowRadius = 3
        digiPic.layer.shadowOffset = CGSize(width: 0, height: 2)






    }
    
    func gradient(frame:CGRect, colors:[CGColor]) -> CAGradientLayer {
            let layer = CAGradientLayer()
            layer.frame = frame
            layer.startPoint = CGPoint(x: 0, y: 0.5)
            layer.endPoint = CGPoint(x: 1, y: 0.5)
            layer.colors = colors
            return layer
        }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
