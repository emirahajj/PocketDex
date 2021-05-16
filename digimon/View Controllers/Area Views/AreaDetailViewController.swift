//
//  AreaDetailViewController.swift
//  digimon
//
//  Created by Emira Hajj on 5/11/21.
//

import UIKit
import Alamofire

class AreaDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ViewStyle {
    
    func styleController(frame: CGRect) {
        let GradientColors = dictionary.AreasColors
        view.createGradientLayer(frame: frame, colors: GradientColors)
    }


    
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let defaults = UserDefaults.standard
    var areaName = String()
    var versionGroup = String()
    
    var version_details = [[String:Any]]()
    var pokemon_encounters = [[String:Any]]()
    
    let dictionary = dict.init()
    let APImanager = APIHelper()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationName.text = areaName
        locationName.formatName()
        versionGroup = defaults.object(forKey: "versionGroup") as! String
        styleController(frame: view.frame)

        
        
        tableView.delegate = self
        tableView.dataSource = self
        print(areaName)
        APImanager.APICall("https://pokeapi.co/api/v2/location-area/\(areaName)/"){theResponse in
            print("hey")
            //print(theResponse)
            //self.pokemon_encounters = theResponse["pokemon_encounters"] as! [[String:Any]]
            
            let allEncounters = theResponse["pokemon_encounters"] as! [[String:Any]]
            
            
            let filteredByVersion = allEncounters.filter({ (value:[String : Any]) -> Bool in
                
                let versionDetails = (value["version_details"]) as! [[String:Any]]
                
                for version in versionDetails {
                    let versionName = (version["version"] as! [String:Any])["name"] as! String
                    let truth = (dict.init().gameVersion2VersionGroup[self.versionGroup]?.contains(versionName))!
                    if (truth){
                        return true
                    }
                }
                return (false)
                 
            })
            
            self.pokemon_encounters = filteredByVersion
            
            //self.version_details = theResponse["version_details"] as! [[String:Any]]
            print(self.pokemon_encounters)
            self.tableView.reloadData()

        }
        
        
        
        //print(defaults.object(forKey: "versionGroup") as! String) //able to print default version group
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! HeaderCell
        let name = ((pokemon_encounters[section])["pokemon"] as! [String:Any])["name"] as! String
        let pokemonURL = ((pokemon_encounters[section])["pokemon"] as! [String:Any])["url"] as! String

        let number = pokemonURL.dropFirst(34).dropLast()
        cell.nameLabel.text = name
        cell.nameLabel.formatName()
        
        let URLstring = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(number).png"
        print(URLstring)
        let url = URL(string: URLstring)!

        cell.pkmnImageView.af.setImage(withURL: url)
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //should filter out here tha matches game version
        
        let filteredArray = ((pokemon_encounters[section])["version_details"] as! [[String:Any]]).filter({ (value:[String : Any]) -> Bool in
            
            let name = (value["version"] as! [String:Any])["name"] as! String
            
            let truth = dict.init().gameVersion2VersionGroup[versionGroup]?.contains(name)

            return (truth!)
             
        })
    
        return (filteredArray).count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //maybe another filter here to filter out sections that have 1 or more pkmn
        return pokemon_encounters.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ((pokemon_encounters[section])["pokemon"] as! [String:Any])["name"] as! String
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EncounterCell") as! EncounterCell
        let versionDetails = (pokemon_encounters[indexPath.section])["version_details"] as! [[String:Any]]
        //another filter step here afterVersionDetails

        let filteredArray = (versionDetails).filter({ (value:[String : Any]) -> Bool in

            let name = (value["version"] as! [String:Any])["name"] as! String
            //print(name)

            let truth = dictionary.gameVersion2VersionGroup[versionGroup]?.contains(name)

            return (truth!)

        })

        
        let cellInfo = filteredArray[indexPath.row]
        let version = (cellInfo["version"] as! [String:Any])["name"] as! String
        //let maxChance = cellInfo["max_chance"] as! String
        let encounterDetails = cellInfo["encounter_details"] as! [[String:Any]]
        let minLevel = (encounterDetails[0])["min_level"] as! Int
        let chance = (encounterDetails[0])["chance"] as! Int
        let maxLevel = (encounterDetails[0])["max_level"] as! Int
        let method = ((encounterDetails[0])["method"] as! [String:Any])["name"] as! String

        cell.versionLabel.text = version
        cell.versionLabel.formatName()
        cell.chanceAmt.text = String(chance) + "%"
        cell.method.text = method
        cell.method.formatName()
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
