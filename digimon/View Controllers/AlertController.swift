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
            self.itemName.text = text
        }
        if let text1 = descText {
            self.desLabel.text = text1
        }
        if let text2 = costText {
            self.costLabel.text = text2
        }
        
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3)

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
