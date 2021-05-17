//
//  GameVersionController.swift
//  digimon
//
//  Created by Emira Hajj on 5/16/21.
//

import UIKit

class GameVersionController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var versionTable: UITableView!
    
    var defaults = UserDefaults.standard
    let dictionary = dict.init()
    var tableViewData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        versionTable.dataSource = self
        versionTable.delegate = self
        
        tableViewData = dictionary.version_groups
        versionTable.reloadData()
        
        let frost = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        frost.frame = view.bounds
        cardView.insertSubview(frost, at: 0)
        cardView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1)
        cardView.layer.cornerRadius = 15
        cardView.backgroundColor = UIColor(red: 0.47, green: 0.42, blue: 0.76, alpha: 1.0)
        cardView.layer.shadowColor = UIColor.darkGray.cgColor
        cardView.layer.shadowRadius = 15
        cardView.layer.shadowOpacity = 1.0
        cardView.layer.shadowOffset = CGSize(width: 0, height: 7)
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = versionTable.dequeueReusableCell(withIdentifier: "sideMenuCell") as! SideMenuCell
        cell.versionLabel.text = tableViewData[indexPath.row]
        cell.versionLabel.formatName()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //add to
        defaults.set(tableViewData[indexPath.row], forKey: "versionGroup")
        self.dismiss(animated: true, completion: nil)
    }

}
