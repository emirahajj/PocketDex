//
//  MoveController.swift
//  digimon
//
//  Created by Emira Hajj on 5/15/21.
//

import UIKit

class MoveController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var moveTable: UITableView!
    
    var moveCriteria = "level-up"
    
    var totalMoveSet : [[String:Any]]?
    var filteredMoveSet : [[String:Any]]?
    let moveTriggers = ["level-up", "machine", "tutor"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        moveTable.dataSource = self
        moveTable.delegate = self
        self.filterMoves()

        
        if let text1 = totalMoveSet {
            self.totalMoveSet = text1
        }
        
        let frost = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        frost.frame = view.bounds
        view.insertSubview(frost, at: 0)
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3)
        moveTable.layer.cornerRadius = 15
        cardView.layer.shadowColor = UIColor.darkGray.cgColor
        cardView.layer.shadowRadius = 15
        cardView.layer.shadowOpacity = 1.0
        cardView.layer.shadowOffset = CGSize(width: 0, height: 7)

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMoveSet!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = moveTable.dequeueReusableCell(withIdentifier: "moveCell") as! MoveCell
        cell.moveName.text = ((filteredMoveSet![indexPath.row])["move"] as! [String:Any])["name"] as? String
        return cell
    }
    
    
    @IBAction func segPick(_ sender: Any) {
        moveCriteria = moveTriggers[segControl.selectedSegmentIndex]
        print(moveTriggers[segControl.selectedSegmentIndex])
        filterMoves()
        //moveTable.reloadData()
        
    }
    func filterMoves() {
        filteredMoveSet = totalMoveSet!.filter{object in
            let version_details = object["version_group_details"] as! [[String:Any]]
            for obj in version_details {
                if let version_group_obj = (obj["move_learn_method"] as! [String: Any])["name"]{
                    return version_group_obj as! String == moveCriteria
                }
            }
            return false
        }
        moveTable.reloadData()
        
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
