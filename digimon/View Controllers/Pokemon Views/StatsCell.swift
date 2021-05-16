//
//  StatsCell.swift
//  digimon
//
//  Created by Emira Hajj on 5/16/21.
//

import UIKit

class StatsCell: UITableViewCell {
    
    
    @IBOutlet weak var statLabel: UILabel!
    
    @IBOutlet weak var amtLabel: UILabel!
    var amountVal = Double()
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        

        // Initialization code
    }
    
    func anim() {
        UIView.animate(withDuration: 0.5, delay: 6.5, options: .curveEaseInOut){
            self.progressBar.setProgress(Float(self.amountVal/255), animated: true)
            print(self.amountVal)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
