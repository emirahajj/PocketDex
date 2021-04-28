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
    
//    @objc func swipedRight(){
//        segControl.selectedSegmentIndex -= 1
//    }
//
//    @objc func swipedLeft(){
//        segControl.selectedSegmentIndex += 1
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
//        var swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipedRight))
//        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
//
//        var swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipedLeft))
//        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        
        
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
                
                for subCategory in self.subcategories {
                    let newSub = cellData(opened: false, title: subCategory, sectionData: [])
                    self.tableViewData.append(newSub)
                }
                self.tableView.reloadData()


            }
        }

        task.resume()
        

        //then iterate to create cellData objects to add to the tableViewData array
        
 
        // Do any additional setup after loading the view.
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
                
                for subCategory in self.subcategories {
                    let newSub = cellData(opened: false, title: subCategory, sectionData: [])
                    self.tableViewData.append(newSub)
                }
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
//            let imageURL = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/nope.png")
//            //print(imageURL)
//            cell.itemImage2?.af.setImage(withURL: imageURL!)
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
        } else {
            //put the other API call in here!
//            if tableViewData[indexPath.section].sectionData[indexPath.row - 1].opened == true {
//
//                tableViewData[indexPath.section].sectionData[indexPath.row - 1].opened = false
//                let sections = IndexSet.init(integer: tableViewData[indexPath.section].sectionData[indexPath.row - 1].sectionData.count)
//                print(sections)
//                tableView.reloadSections(sections, with: .none)
//            } else {
//                tableViewData[indexPath.section].sectionData[indexPath.row - 1].opened = true
//                let sections = IndexSet.init(integer: tableViewData[indexPath.section].sectionData[indexPath.row - 1].sectionData.count)
//                tableViewData[indexPath.section].sectionData[indexPath.row - 1].sectionData = ["text"]
//                print(sections)
//
//                tableView.reloadSections(sections, with: .none)
//            }
//            tableView.reloadSections(<#T##sections: IndexSet##IndexSet#>, with: <#T##UITableView.RowAnimation#>)
            //print("hey")
            
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
