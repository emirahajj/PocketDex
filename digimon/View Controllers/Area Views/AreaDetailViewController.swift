//
//  AreaDetailViewController.swift
//  digimon
//
//  Created by Emira Hajj on 5/11/21.
//

import UIKit

class AreaDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    let defaults = UserDefaults.standard
    var areaName = String()
    
    var version_details = [[String:Any]]()
    var pokemon_encounters = [[String:Any]]()
    
    func APICall(_ a : String, complete: @escaping ([String:Any])->()) {
        var result = [String:Any]()
        let url1 = URL(string: a)!
        //print("URL: \(url1)")
        let request = URLRequest(url: url1, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) {(data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed]) as! [String: Any]
                result = dataDictionary as [String: Any]
                complete(result)
            }
        }
        task.resume()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        print(areaName)
        APICall("https://pokeapi.co/api/v2/location-area/\(areaName)/"){theResponse in
            print("hey")
            //print(theResponse)
            self.pokemon_encounters = theResponse["pokemon_encounters"] as! [[String:Any]]
            //self.version_details = theResponse["version_details"] as! [[String:Any]]
            print(self.pokemon_encounters)
            self.tableView.reloadData()

        }
        
        print(defaults.object(forKey: "versionGroup") as! String) //able to print default
        


        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //should filter out here tha matches game version
        return ((pokemon_encounters[section])["version_details"] as! [[String:Any]]).count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return pokemon_encounters.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ((pokemon_encounters[section])["pokemon"] as! [String:Any])["name"] as! String
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EncounterCell") as! EncounterCell
        let versionDetails = (pokemon_encounters[indexPath.section])["version_details"] as! [[String:Any]]
        let cellInfo = versionDetails[indexPath.row]
        let version = (cellInfo["version"] as! [String:Any])["name"] as! String
        //let maxChance = cellInfo["max_chance"] as! String
        let encounterDetails = cellInfo["encounter_details"] as! [[String:Any]]
        let minLevel = (encounterDetails[0])["min_level"] as! Int
        let chance = (encounterDetails[0])["chance"] as! Int
        let maxLevel = (encounterDetails[0])["max_level"] as! Int
        let method = ((encounterDetails[0])["method"] as! [String:Any])["name"] as! String

        cell.versionLabel.text = version
        cell.chanceAmt.text = String(chance)
        cell.method.text = method
        cell.minLevelAmt.text = String(minLevel)
        cell.maxLevelAmt.text = String(maxLevel)
        return cell
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
