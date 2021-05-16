//
//  GameVersionController.swift
//  digimon
//
//  Created by Emira Hajj on 5/16/21.
//

import UIKit

protocol AddVersionGroupDelegate {
    func setVersionGroup(versionGroup: String)
}

class GameVersionController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //var delegate: AddVersionGroupDelegate?

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
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = versionTable.dequeueReusableCell(withIdentifier: "sideMenuCell") as! SideMenuCell
        cell.versionLabel.text = tableViewData[indexPath.row]
        cell.versionLabel.textColor = UIColor.black
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //add to
        defaults.set(tableViewData[indexPath.row], forKey: "versionGroup")
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
