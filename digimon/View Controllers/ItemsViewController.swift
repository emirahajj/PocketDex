//
//  ItemsViewController.swift
//  digimon
//
//  Created by Emira Hajj on 3/27/21.
//

import UIKit
import Alamofire


struct cellData {
    var opened = Bool()
    var title = String()
    var sectionData = [String]()
}
//struct innerData {
//    var opened = Bool()
//    var title = String()
//    var sectionData = [String]()
//}

class ItemsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var bagImage: UIImageView!
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    //try making another struct and embedding that as the section data of the first
    var tableViewData = [cellData]()
    
    //segmented control
    let sections = ["machines", "pokeballs", "medicine", "berries", "mail", "battle","key","misc"]
    var subcategories : [String] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

        
        //get the selected index item-pocket
        let bagPocket = sections[segControl.selectedSegmentIndex]
        print(bagPocket)
        
        //get the item-categories that belong to the selected index
        
        let url = URL(string: "https://pokeapi.co/api/v2/item-pocket/\(bagPocket)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                let categorieObjects = dataDictionary["categories"] as! [[String:Any]]
                var newSubCategories : [cellData] = []
                for category in categorieObjects {
                    let newCellData = cellData(opened: false, title: category["name"] as! String, sectionData: [])
                    newSubCategories.append(newCellData)
                }
                
                self.tableViewData = newSubCategories
                self.tableView.reloadData()


            }
        }

        task.resume()
    }
    
    
    @IBAction func onSwipeLeft(_ sender: Any) {
        segControl.selectedSegmentIndex += 1
        self.onSegChange(self)

    }
    
    @IBAction func onSwipeRight(_ sender: Any) {
        segControl.selectedSegmentIndex -= 1
        self.onSegChange(self)

    }
    @IBAction func onSegChange(_ sender: Any) {
        let bagPocket = sections[segControl.selectedSegmentIndex]
        
        let url = URL(string: "https://pokeapi.co/api/v2/item-pocket/\(bagPocket)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                let categorieObjects = dataDictionary["categories"] as! [[String:Any]]
                var newSubCategories : [cellData] = []
                for category in categorieObjects {
                    let newCellData = cellData(opened: false, title: category["name"] as! String, sectionData: [])
                    newSubCategories.append(newCellData)
                }
                
                self.tableViewData = newSubCategories
                self.tableView.reloadData()


            }
        }

        task.resume()
        
        
        //animate the bag to shake a lil
        
        UIView.animate(withDuration: 0.05, animations: {
            self.bagImage.transform = CGAffineTransform(rotationAngle: (4 * .pi) / 180.0)
        }, completion: { _ in
            UIView.animate(withDuration: 0.05) {
                self.bagImage.transform = CGAffineTransform(rotationAngle: -1 * (4 * .pi) / 180.0)
            }
        })
        

        self.tableView.reloadData()


        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[section].opened {
            return tableViewData[section].sectionData.count + 1
        } else {
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
    
    func formatName(string : String) -> String {
        let newString = string.replacingOccurrences(of: "-", with: " ")
        return newString.capitalized
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //need to check if the sgemented control got switched or not
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InnerItemCell") as! InnerItemCell

            cell.label?.text = formatName(string: tableViewData[indexPath.section].title)
            cell.backgroundColor = UIColor.init(red: 0.9, green: 0.36, blue: 0.34, alpha: 1.0)
            return cell

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as! ItemCell
            cell.label?.text = formatName(string: tableViewData[indexPath.section].sectionData[indexPath.row - 1])
            //need to take care of TM/HM sprites
            let imageURL = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/\(tableViewData[indexPath.section].sectionData[indexPath.row - 1]).png")
            cell.itemImage2?.af.setImage(withURL: imageURL!)
            cell.backgroundColor = UIColor.white
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //refactor--use title for header in section, and keep the
        //only want to collapse first when first one is clicked]
        
        print("This is in section: \(indexPath.section) and row: \(indexPath.row)")
        if indexPath.row == 0 {
            if tableViewData[indexPath.section].opened == true {
                tableViewData[indexPath.section].opened = false
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            } else {
                tableViewData[indexPath.section].opened = true

                let sections = IndexSet.init(integer: indexPath.section)
                
                let url = URL(string: "https://pokeapi.co/api/v2/item-category/\(tableViewData[indexPath.section].title)")!
                let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
                let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
                let task = session.dataTask(with: request) { (data, response, error) in
                    // This will run when the network request returns
                    if let error = error {
                        print(error.localizedDescription)
                    } else if let data = data {
                        let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                        //tableviewdata[indexpath.section].sectionData = [our new aray]
                        let categorieObjects = dataDictionary["items"] as! [[String:Any]]
                        var categoryNames: [String] = []
                        for category in categorieObjects {
//                             let innerSection = innerData(opened: false, title: category["name"] as! String, sectionData: [])
                            categoryNames.append(category["name"] as! String)
                        }
                        self.tableViewData[indexPath.section].sectionData = categoryNames
                        self.tableView.reloadSections(sections, with: .none)
                    }
                }
                

                task.resume()
            }
        } else { //popup goes here
            
            //make api call 
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let myAlert = storyboard.instantiateViewController(withIdentifier: "alert") as? AlertController {
                
                let url = URL(string: "https://pokeapi.co/api/v2/item/\(tableViewData[indexPath.section].sectionData[indexPath.row - 1])")!
                let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
                let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
                let task = session.dataTask(with: request) { (data, response, error) in
                    // This will run when the network request returns
                    if let error = error {
                        print(error.localizedDescription)
                    } else if let data = data {
                        let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                        //tableviewdata[indexpath.section].sectionData = [our new aray]
                        let effect = ((dataDictionary["effect_entries"] as! [[String:Any]])[0])["short_effect"] as! String
                        
                        myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                        myAlert.labelText = self.tableViewData[indexPath.section].sectionData[indexPath.row - 1]
                        myAlert.descText = effect
                        myAlert.costText = String(dataDictionary["cost"] as! Int)
                        myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                        self.present(myAlert, animated: true, completion: nil)

                        
                        
                    }
                }
                

                task.resume()

            
            }
//            myAlert.itemName!.text = "hey"

            
            
        } //we can put a segue here to go to that items individual page
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
