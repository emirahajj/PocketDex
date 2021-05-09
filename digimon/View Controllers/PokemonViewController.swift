//
//  ViewController.swift
//  digimon
//
//  Created by Emira Hajj on 2/4/21.
//

import UIKit
import AlamofireImage


class PokemonViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    var isMenuActive = false
    let menuTable = UITableView() //for side menu
    var pokemon = [[String:Any]]() //dictionary that stores URL + pokemon names
    var secondary = [[String:Any]]() //duplicate of pokemon to use search feature
    var picString = String() //string representing pokemon image
    @IBOutlet weak var pokeContent: UIView!
    @IBOutlet weak var tableView: UITableView! //for pokemon
    @IBOutlet weak var searchBar: UISearchBar!
    

    let gens = ["R/B/Y", "G/S/C", "R/S/E", "D/P", "Plat.", "HG/SS", "B/W", "B2/W2"]
    let version_groups = ["red-blue", "yellow", "gold-silver", "crystal", "ruby-sapphire", "emerald", "firered-leafgreen", "diamond-pearl", "platinum", "heartgold-soulsilver", "black-white", "black-2-white-2" , "x-y", "omega-ruby-alpha-sapphire", "sun-moon", "ultra-sun-ultra-moon"]
    let typesArray = ["normal", "fighting", "flying", "poison", "ground", "rock", "bug", "ghost", "steel", "fire", "water", "grass", "electric", "psychic", "ice", "dragon", "dark", "fairy"]
    let menuContent = [
        ["Gen I", "Gen II", "Gen III", "Gen IV", "Gen V", "Gen VI", "Gen VII"],
        ["red-blue", "yellow", "gold-silver", "crystal", "ruby-sapphire", "emerald", "firered-leafgreen", "diamond-pearl", "platinum", "heartgold-soulsilver", "black-white", "black-2-white-2" , "x-y", "omega-ruby-alpha-sapphire", "sun-moon", "ultra-sun-ultra-moon"],
        ["normal", "fighting", "flying", "poison", "ground", "rock", "bug", "ghost", "steel", "fire", "water", "grass", "electric", "psychic", "ice", "dragon", "dark", "fairy"]]
    let menuTitles = ["Generations", "Game Versions", "Types"]
    
    let genLookup = [
        "R/B/Y" : "https://pokeapi.co/api/v2/pokedex/1/",
        "G/S/C" : "https://pokeapi.co/api/v2/pokedex/3/",
        "R/S/E" : "https://pokeapi.co/api/v2/pokedex/4/",
        "D/P" : "https://pokeapi.co/api/v2/pokedex/5/",
        "Plat." : "https://pokeapi.co/api/v2/pokedex/6/",
        "HG/SS" : "https://pokeapi.co/api/v2/pokedex/7/",
        "B/W" : "https://pokeapi.co/api/v2/pokedex/8/",
        "B2/W2" : "https://pokeapi.co/api/v2/pokedex/9/",
    ]
    //array of integer ranges to represent which generation to filter by
    let dexEntryRanges = [1..<151, 152..<251, 252..<386, 387..<493, 494..<649, 650..<722, 722..<809]
    
    //the set that will contain the ranges to filter by
    var filterRanges:Set<Range<Int>> = []
    
    
    
    let gameVersion = String()
    let generation = String()
    var searchType = String()
    var filterTypes:Set<String> = []

    
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
    
    func gradient(frame:CGRect, colors:[CGColor]) -> CAGradientLayer {
            let layer = CAGradientLayer()
            layer.frame = frame
            layer.startPoint = CGPoint(x: 0, y: 1)
            layer.endPoint = CGPoint(x: 0, y: 0)
            layer.colors = colors
            return layer
        }
    
    

    
    func createSideMenu(view: UIView) {
        
        let rect = CGRect(x: 0, y: 0, width: view.layer.bounds.width * 0.4, height: view.layer.bounds.width)
        let newView = UIView(frame:rect)
        
        self.menuTable.frame = newView.frame
        self.menuTable.allowsMultipleSelection = true
        newView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        newView.translatesAutoresizingMaskIntoConstraints = false
        menuTable.translatesAutoresizingMaskIntoConstraints = false

        
        view.addSubview(newView)
        view.sendSubviewToBack(newView)
        newView.addSubview(self.menuTable)
        
        newView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        newView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        newView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        newView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
        
        menuTable.topAnchor.constraint(equalTo: newView.safeAreaLayoutGuide.topAnchor).isActive = true
        menuTable.bottomAnchor.constraint(equalTo: newView.bottomAnchor).isActive = true
        menuTable.leadingAnchor.constraint(equalTo: newView.leadingAnchor).isActive = true
        menuTable.widthAnchor.constraint(equalTo: newView.widthAnchor).isActive = true
        
        menuTable.backgroundColor = UIColor.clear
        
        menuTable.reloadData()
        
        print(MemoryLayout.size(ofValue: self.menuTable))
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //super.view.layoutIfNeeded()
        menuTable.delegate = self
        menuTable.dataSource = self
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self

        createSideMenu(view: view)

        let blue = UIColor(red: 0.62, green: 0.28, blue: 0.76, alpha: 1.00)
        let green = UIColor(red: 0.27, green: 0.64, blue: 0.84, alpha: 1.00)
        let array = [blue.cgColor, green.cgColor]
        pokeContent.layer.insertSublayer(gradient(frame: view.bounds, colors:array), at:0)
        view.layer.insertSublayer(gradient(frame: view.bounds, colors:array ), at:0)

        
        searchBar.searchBarStyle = .minimal
        searchBar.setBackgroundImage(UIImage(ciImage: .white), for: UIBarPosition(rawValue: 0)!, barMetrics:.default)
        searchBar.searchTextField.attributedPlaceholder =  NSAttributedString.init(string: "Search Pokémon", attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray])
        
                
        let url = URL(string: "https://pokeapi.co/api/v2/pokedex/1/")!
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                self.pokemon = dataDictionary["pokemon_entries"] as! [[String:Any]]
                self.secondary = dataDictionary["pokemon_entries"] as! [[String:Any]]
                self.tableView.reloadData()

            }
        }

        task.resume()

        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch tableView {
        case menuTable:
            return menuContent.count
        default:
             return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {


        switch tableView {
        case menuTable:
            let vw = UIView()
            vw.translatesAutoresizingMaskIntoConstraints = false

            let label = UILabel(frame:  CGRect(x: 0, y: 0, width: tableView.frame.width, height: 20))
            //label.translatesAutoresizingMaskIntoConstraints = false


            label.text = menuTitles[section]
            label.textColor = UIColor.white
            label.textAlignment = NSTextAlignment.center
            label.font = UIFont.systemFont(ofSize: 16, weight: .black)

            vw.backgroundColor = UIColor(red: 0.47, green: 0.33, blue: 0.69, alpha: 1.00)
            vw.layer.cornerRadius = 6
            vw.addSubview(label)

//            label.centerXAnchor.constraint(equalTo: vw.centerXAnchor).isActive = true
//            label.centerYAnchor.constraint(equalTo: vw.centerYAnchor).isActive = true

            return vw
        default:
             return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case menuTable:
            return 20
        default:
            return UITableView.automaticDimension
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case menuTable:
            return menuContent[section].count
        default:
             return secondary.count
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        switch tableView {
        case menuTable:
            switch indexPath.section {
            //generation toggle
            case 0:
                
                filterRanges.remove(dexEntryRanges[indexPath.row])
                if filterRanges.count == 0 {
                    self.secondary = self.pokemon
                }

            case 2:
                filterTypes = []
                self.secondary = self.pokemon

            default:
                print("not a generation")
            }
        default:
             break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case menuTable:
            switch indexPath.section {
            //generations
            case 0:
                
                filterRanges.insert(dexEntryRanges[indexPath.row])

            //game versions
            case 2:
                searchType = typesArray[indexPath.row]
//                let num = String(indexPath.row + 1)
                APICall("https://pokeapi.co/api/v2/type/\(searchType)"){response in
                    let pokemonArray = response["pokemon"] as! [[String:Any]]
                    self.filterTypes = Set(pokemonArray.map { ($0["pokemon"] as! [String:Any])["name"] as! String })
                    print(self.filterTypes)

                    
                }
                
            default:
                print("not a generation")
            }
        default:
             break
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch tableView {
        case menuTable:
            var cell = SideMenuCell()
            cell.labelText = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 20))
            cell.labelText.adjustsFontSizeToFitWidth = true
            cell.labelText.text = menuContent[indexPath.section][indexPath.row]
            cell.labelText.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
            cell.labelText.font = UIFont(name: "Menlo-Bold", size: 12)
            cell.labelText.textColor = UIColor.black
            cell.labelText.textAlignment = NSTextAlignment.center
            //cell.heightAnchor.constraint(equalToConstant: 12).isActive = true
            cell.addSubview(cell.labelText)
            
            cell.labelText.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            cell.labelText.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            cell.backgroundColor = UIColor.clear
            
            

//            cell = tableView.dequeueReusableCell(withIdentifier: "PokeCell") as! PokeCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PokeCell") as! PokeCell
            let mypoke = secondary[indexPath.row]
            let name = (mypoke["pokemon_species"] as! [String:Any])["name"] as! String //name of pokemon
            let localDexNumber = mypoke["entry_number"] as! Int
            let cellPicString = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-vii/icons/\(localDexNumber).png"
            let picstring = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(localDexNumber).png"
            let photoURL = URL(string: cellPicString)
            cell.digiPic.af.setImage(withURL: photoURL!)
            cell.digiPic.layer.magnificationFilter = CALayerContentsFilter.nearest
            //cell.digiPic.backgroundColor = UIColor.red
        
            cell.digiLevel.text = String(format: "%03d", localDexNumber)

            //capitalizing first letter since its all lowercase
            let properName = name.prefix(1).uppercased() + name.lowercased().dropFirst()
            cell.properName = properName
            cell.digiName.text = properName
            cell.myPic = picstring
            return cell
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //secondary = []
        if searchText == "" {
            filter()
        }
        else{
            let query = searchBar.text!.lowercased()
            print(query)
            secondary = secondary.filter({ (value:[String : Any]) -> Bool in
                
                let name = (value["pokemon_species"] as! [String:Any])["name"] as! String
                
                return (name.starts(with: query))
                 
            })

        }
        tableView.reloadData()

    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gens.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gens[row]
    }
    
    

    
    @IBAction func buttonTap(_ sender: Any) {

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
            self.pokeContent.frame.origin.x = self.isMenuActive ? 0 : self.pokeContent.frame.width * 0.4
        } completion: { (finished) in
            print("hi")
            self.isMenuActive.toggle()
            self.tableView.isUserInteractionEnabled.toggle()
            if (!self.isMenuActive){
                
                //change the filterRanges here
                //will throw an error if you click on another section that has section that go past
                
                //the actual function that does the filtering by generations picked
                self.filter()
                


            }
            
            self.tableView.reloadData()
        }
        print(filterRanges)

    }
    
    func filter() {
        //there is a generation to fill
        if (!filterRanges.isEmpty){
            self.secondary = self.pokemon.filter({ (value:[String : Any]) -> (Bool) in
                let name = (value["pokemon_species"] as! [String:Any])["name"] as! String

            
            var isFound = false
            let number = value["entry_number"] as! Int
            for range in self.filterRanges {
                //have to or these somehow
                if range.contains(number) {
                    return true
                }
                isFound = range.contains(number)
                
            }
            return isFound
            })}
        //no generation, that means all the filters below it
        else if (filterRanges.isEmpty) {
            secondary = pokemon
        }
        if (!self.filterTypes.isEmpty){
            self.secondary = self.secondary.filter({ (value:[String : Any]) -> (Bool) in
                //get name of pokemon currently in that list
                //then ask if that name is contained within the filterTypes array taht holds the names of all the pokemon of that type
                let name = (value["pokemon_species"] as! [String:Any])["name"] as! String
                return self.filterTypes.contains(name)
        })}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("i got called")
        

        //ensuring the sender is the type of cell we want
        let cell = sender as! PokeCell

        //getting the index of that tapped cell
        let index = tableView.indexPath(for: cell)!
                
        //the url for the pokemon information--remmeber this is just the name +
        //)
        var pokeURL = (secondary[index.row]["pokemon_species"] as! [String:Any])["url"] as! String
        pokeURL = "https://pokeapi.co/api/v2/pokemon/" + pokeURL.dropFirst(42)
        print(pokeURL)

        //create a variable that represents the viewcontroller we cwant to navigate to
        let dexViewController = segue.destination as! DexEntryController
        
        //need to pass image and url for API call to the next screen
        dexViewController.pokeURL = pokeURL
        dexViewController.picString = cell.myPic!
        dexViewController.formattedName = cell.properName!
        dexViewController.id = cell.digiLevel.text!
        
    
    }


}

