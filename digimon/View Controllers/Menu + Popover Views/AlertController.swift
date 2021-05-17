//
//  AlertController.swift
//  digimon
//
//  Created by Emira Hajj on 5/1/21.
//

import UIKit

class AlertController: UIViewController {

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    
    @IBOutlet weak var costLabel: UILabel!
    
    var labelText: String? //IB outlets are not connected when you instantiate a VC hence, we need the if let
    var descText: String?
    var costText: String?
    
    
    @IBOutlet weak var card: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let text = labelText {
            self.itemName.text = text.replacingOccurrences(of: "-", with: " ").capitalized
        }
        if let text1 = descText {
            self.desLabel.text = text1
        }
        if let text2 = costText {
            self.costLabel.text = text2
        }
        
        let frost = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        frost.frame = view.bounds
        view.insertSubview(frost, at: 0)
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3)
        card.layer.cornerRadius = 15
        card.backgroundColor = UIColor(red: 0.38, green: 0.27, blue: 0.57, alpha: 0.4)
        card.layer.shadowColor = UIColor.darkGray.cgColor
        card.layer.shadowRadius = 15
        card.layer.shadowOpacity = 1.0
        card.layer.shadowOffset = CGSize(width: 0, height: 7)
        


        // Do any additional setup after loading the view.
    }
    

    @IBAction func onTap(_ sender: Any) {
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
