//
//  ItemsViewController.swift
//  digimon
//
//  Created by Emira Hajj on 3/27/21.
//

import UIKit

//creating a struct to be able to "collapse" rows to show the subobjects they contain
struct cellData {
    var opened = Bool()
    var title = String()
    var sectionData = [String]()
}

class ItemsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ViewStyle {
    func styleController(frame: CGRect) {
        let GradientColors = dictionary.DexEntryColors
        view.createGradientLayer(frame: frame, colors: GradientColors)
    }
    

    @IBOutlet weak var bagImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var downloadTask: URLSessionDownloadTask?

    
    var tableViewData = [cellData]()
    
    //segmented control
    let sections = ["medicine", "pokeballs", "machines", "berries", "mail", "battle","key","misc"]
    var subcategories : [String] = []
    var segControl = UISegmentedControl(items: ["medicine", "pokeballs", "machines", "berries", "mail", "battle","key","misc"])

    let dictionary = dict.init()
    let APImanager = APIHelper()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        segControl.selectedSegmentIndex = 0
        styleController(frame: view.frame)

        
        //get the selected index item-pocket
        let bagPocket = sections[segControl.selectedSegmentIndex]
        
        categoryLabel.text = bagPocket.capitalized

        
        //get the item-categories that belong to the selected index
        
        APImanager.APICall("https://pokeapi.co/api/v2/item-pocket/\(bagPocket)") {response in
            let categorieObjects = response["categories"] as! [[String:Any]]
            var newSubCategories : [cellData] = []
            for category in categorieObjects {
                let newCellData = cellData(opened: false, title: category["name"] as! String, sectionData: [])
                newSubCategories.append(newCellData)
            }

            self.tableViewData = newSubCategories
            self.tableView.reloadData()
        }
        
    }
    
    func gradient(frame:CGRect, colors:[CGColor]) -> CAGradientLayer {
            let layer = CAGradientLayer()
            layer.frame = frame
            layer.startPoint = CGPoint(x: 0, y: 1)
            layer.endPoint = CGPoint(x: 0, y: 0)
            layer.colors = colors
            return layer
        }
    
    @IBAction func onSwipeLeft(_ sender: Any) {
        if segControl.selectedSegmentIndex < sections.count - 1 {
            segControl.selectedSegmentIndex += 1
        }
        self.onSegChange(self)

    }
    
    @IBAction func onSwipeRight(_ sender: Any) {
        if segControl.selectedSegmentIndex > 0 {
            segControl.selectedSegmentIndex -= 1

        }
        
        self.onSegChange(self)

    }
    
    @IBAction func onSegChange(_ sender: Any) {
        let bagPocket = sections[segControl.selectedSegmentIndex]
        categoryLabel.text = bagPocket.capitalized
        imageView.image = UIImage(named: "\(bagPocket).png")
        
        APImanager.APICall("https://pokeapi.co/api/v2/item-pocket/\(bagPocket)"){response in
            
            let categorieObjects = response["categories"] as! [[String:Any]]
            var newSubCategories : [cellData] = []
            for category in categorieObjects {
                let newCellData = cellData(opened: false, title: category["name"] as! String, sectionData: [])
                newSubCategories.append(newCellData)
            }
            
            self.tableViewData = newSubCategories
            self.tableView.reloadData()
        }
    
        //animate the bag to shake a lil
        UIView.animate(withDuration: 0.05, animations: {
            self.bagImage.transform = CGAffineTransform(rotationAngle: (4 * .pi) / 180.0)
        }, completion: { _ in
            UIView.animate(withDuration: 0.05) {
                self.bagImage.transform = CGAffineTransform.identity
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InnerItemCell") as! InnerItemCell

            cell.label?.text = tableViewData[indexPath.section].title
            cell.label.formatName()
            cell.backgroundColor = UIColor(red: 0.38, green: 0.27, blue: 0.57, alpha: 1.00)
            return cell

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as! ItemCell
            cell.label?.text = tableViewData[indexPath.section].sectionData[indexPath.row - 1]
            cell.label.formatName()
            //need to take care of TM/HM sprites
            var itemVarPic = tableViewData[indexPath.section].sectionData[indexPath.row - 1]
            if segControl.selectedSegmentIndex == 2 {
                itemVarPic = "tm-normal"
            }
            
            cell.itemImage2.image = UIImage(systemName: "square")
            if let smallURL = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/\(itemVarPic).png") {
                downloadTask = cell.itemImage2.loadImage(url: smallURL)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        if indexPath.row == 0 {
            if tableViewData[indexPath.section].opened == true {
                tableViewData[indexPath.section].opened = false
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            } else {
                tableViewData[indexPath.section].opened = true
                let sections = IndexSet.init(integer: indexPath.section)
                APImanager.APICall("https://pokeapi.co/api/v2/item-category/\(tableViewData[indexPath.section].title)"){response in
                    let categorieObjects = response["items"] as! [[String:Any]]
                    var categoryNames: [String] = []
                    for category in categorieObjects {
                        categoryNames.append(category["name"] as! String)
                    }
                    self.tableViewData[indexPath.section].sectionData = categoryNames
                    self.tableView.reloadSections(sections, with: .none)

                }
                
            }
        } else { //popup goes here
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let myAlert = storyboard.instantiateViewController(withIdentifier: "alert") as? AlertController {
                
                APImanager.APICall("https://pokeapi.co/api/v2/item/\(tableViewData[indexPath.section].sectionData[indexPath.row - 1])"){response in
                    let effect = ((response["effect_entries"] as! [[String:Any]])[0])["short_effect"] as! String
                    
                    myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    myAlert.labelText = self.tableViewData[indexPath.section].sectionData[indexPath.row - 1]
                    myAlert.descText = effect
                    myAlert.costText = String(response["cost"] as! Int)
                    myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                    self.present(myAlert, animated: true, completion: nil)
                    self.tableView.deselectRow(at: indexPath, animated: true)

                }
                
            }

        }
    }

}
