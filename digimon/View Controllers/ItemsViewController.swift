//
//  ItemsViewController.swift
//  digimon
//
//  Created by Emira Hajj on 3/27/21.
//

import UIKit


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

    @IBOutlet weak var tableView: UITableView!
    
    //try making another struct and embedding that as the section data of the first
    var tableViewData = [cellData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.reloadData()
        let dict = [
            "machines" : " "
        ]
        let sections = ["machines", "pokeballs", "medicine", "berries", "mail", "battle","key","misc"]
        tableViewData = [
            cellData(opened: false, title: "machines", sectionData: []),
            cellData(opened: false, title: "pokeballs", sectionData: []),
            cellData(opened: false, title: "medicine", sectionData: []),
            cellData(opened: false, title: "berries", sectionData: []),
            cellData(opened: false, title: "mail", sectionData: []),
            cellData(opened: false, title: "battle", sectionData: []),
            cellData(opened: false, title: "key", sectionData: []),
            cellData(opened: false, title: "misc", sectionData: [])]

        // Do any additional setup after loading the view.
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
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Section \(section)"
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as! ItemCell
        
        if indexPath.row == 0 {
            cell.textLabel?.text = tableViewData[indexPath.section].title
            cell.backgroundColor = UIColor.green
            return cell
        }
        cell.textLabel?.text = tableViewData[indexPath.section].sectionData[indexPath.row - 1]
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //refactor--use title for header in section, and keep the
        //only want to collapse first when first one is clicked
        if indexPath.row == 0 {
            if tableViewData[indexPath.section].opened == true {
                tableViewData[indexPath.section].opened = false
                let sections = IndexSet.init(integer: indexPath.section)
                print(sections.count)
                tableView.reloadSections(sections, with: .none)
            } else {
                tableViewData[indexPath.section].opened = true

                let sections = IndexSet.init(integer: indexPath.section)
                
                let url = URL(string: "https://pokeapi.co/api/v2/item-pocket/\(tableViewData[indexPath.section].title)")!
                let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
                let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
                let task = session.dataTask(with: request) { (data, response, error) in
                    // This will run when the network request returns
                    if let error = error {
                        print(error.localizedDescription)
                    } else if let data = data {
                        let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                        
                        let categorieObjects = dataDictionary["categories"] as! [[String:Any]]
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
