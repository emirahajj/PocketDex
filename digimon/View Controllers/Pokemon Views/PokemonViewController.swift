//
//  ViewController.swift
//  digimon
//
//  Created by Emira Hajj on 2/4/21.
//

import UIKit


class PokemonViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, ViewStyle {

    var isMenuActive = false //boolean to control side menu
    let menuTable = UITableView() //tableview for side menu
    var pokemon = [[String:Any]]() //dictionary that stores URL + pokemon names
    var secondary = [[String:Any]]() //duplicate of pokemon to use search feature
    var picString = String() //string representing pokemon image
    let defaults = UserDefaults.standard
    var downloadTask: URLSessionDownloadTask?

    
    @IBOutlet weak var pokeContent: UIView!
    @IBOutlet weak var tableView: UITableView! //for pokemon
    @IBOutlet weak var searchBar: UISearchBar!
    
    let menuContent = dict.init().menuContent
    let menuTitles = dict.init().menuTitles
    let typesArray = dict.init().typesArray
    let versionGroups = dict.init().version_groups
    let dictionary = dict.init()
    let APImanager = APIHelper()
    
    //the set that will contain the ranges to filter by
    
    let gameVersion = String()
    let generation = String()
    var searchType = String()
    var filterTypes:Set<String> = []


    func createSideMenu(view: UIView) {
        
        let rect = CGRect(x: 0, y: 0, width: view.layer.bounds.width * 0.4, height: pokeContent.layer.bounds.height)
        let newView = UIView(frame:rect)
        
        self.menuTable.frame = newView.frame
        self.menuTable.allowsMultipleSelection = true
        menuTable.backgroundColor = UIColor.clear
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
        
        menuTable.reloadData()
        
    }
    
    func styleController(frame: CGRect) {
        let GradientColors = dictionary.DexEntryColors
        pokeContent.createGradientLayer(frame: frame, colors: GradientColors)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        filter()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !UserDefaults.exists(key: "versionGroup"){
            defaults.set("x-y", forKey: "versionGroup")
        }
        
        styleController(frame: pokeContent.frame)
        menuTable.delegate = self
        menuTable.dataSource = self
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        pokeContent.layer.shadowColor = UIColor.darkGray.cgColor
        pokeContent.layer.shadowRadius = 7
        pokeContent.layer.shadowOpacity = 1
        pokeContent.layer.shadowOffset = CGSize.init(width: 0, height: 7)
        
        tabBarController?.tabBar.backgroundImage = UIImage(named: "transparent.png")
        tabBarController?.tabBar.unselectedItemTintColor = UIColor(red: 0.29, green: 0.22, blue: 0.45, alpha: 1.00)
        

    
        tabBarController?.tabBar.backgroundColor = UIColor(red: 0.62, green: 0.28, blue: 0.76, alpha: 1.00)
        searchBar.searchBarStyle = .minimal
        searchBar.setBackgroundImage(UIImage(ciImage: .white), for: UIBarPosition(rawValue: 0)!, barMetrics:.default)
        searchBar.searchTextField.attributedPlaceholder =  NSAttributedString.init(string: "Search Pokémon", attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray])

        createSideMenu(view: view)

        let blue = UIColor(red: 0.62, green: 0.28, blue: 0.76, alpha: 1.00)
        let green = UIColor(red: 0.27, green: 0.64, blue: 0.84, alpha: 1.00)
        let array = [blue.cgColor, green.cgColor]
        view.createGradientLayer(frame: view.bounds, colors: array)
        
        APImanager.APICall("https://pokeapi.co/api/v2/pokedex/1/"){response in
            self.pokemon = response["pokemon_entries"] as! [[String:Any]]
            self.secondary = response["pokemon_entries"] as! [[String:Any]]
            self.tableView.reloadData()
            
        }
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
            label.text = menuTitles[section]
            label.textColor = UIColor.white
            label.textAlignment = NSTextAlignment.center
            label.font = UIFont.systemFont(ofSize: 16, weight: .black)

            vw.backgroundColor = UIColor(red: 0.47, green: 0.33, blue: 0.69, alpha: 1.00)
            vw.layer.cornerRadius = 6
            vw.addSubview(label)

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
            return 60
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
            filterTypes = []
            self.secondary = self.pokemon
        default:
             break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case menuTable:
            searchType = typesArray[indexPath.row]
            APImanager.APICall("https://pokeapi.co/api/v2/type/\(searchType)"){response in
                let pokemonArray = response["pokemon"] as! [[String:Any]]
                self.filterTypes = Set(pokemonArray.map { ($0["pokemon"] as! [String:Any])["name"] as! String })
                print(self.filterTypes)
            }
        default:
             break
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch tableView {
        case menuTable:
            let cell = SideMenuCell()
            cell.formatCell(width: tableView.frame.width, height: 20)
            cell.labelText.text = menuContent[indexPath.section][indexPath.row]
            cell.labelText.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            cell.labelText.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PokeCell") as! PokeCell
            let mypoke = secondary[indexPath.row]
            let name = (mypoke["pokemon_species"] as! [String:Any])["name"] as! String //name of pokemon
            let localDexNumber = mypoke["entry_number"] as! Int

            let picstring = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(localDexNumber).png"

            if let smallURL = URL(string: picstring) {
                downloadTask = cell.digiPic.loadImage(url: smallURL)
            }
            cell.digiPic.layer.magnificationFilter = CALayerContentsFilter.nearest
        
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
    
    @IBAction func buttonTap(_ sender: Any) {

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
            self.pokeContent.frame.origin.x = self.isMenuActive ? 0 : self.pokeContent.frame.width * 0.4
        } completion: { (finished) in
            print("hi")
            self.isMenuActive.toggle()
            self.tableView.isUserInteractionEnabled.toggle()
            if (!self.isMenuActive){
                //the actual function that does the filtering by generations picked
                self.filter()
            }
            
            self.tableView.reloadData()
        }
    }
    //filters the array that holds the pokemon by gameversion + type
    func filter() {
        let versionGroup = defaults.object(forKey: "versionGroup") as! String
        self.secondary = self.pokemon.filter({ (value:[String : Any]) -> (Bool) in
            var isFound = false
            let number = value["entry_number"] as! Int
                if dictionary.versionGroupRanges[versionGroup]!.contains(number) {
                    return true
                }
                isFound = dictionary.versionGroupRanges[versionGroup]!.contains(number)

            return isFound
        })
        if (!self.filterTypes.isEmpty){
            self.secondary = self.secondary.filter({ (value:[String : Any]) -> (Bool) in
                let name = (value["pokemon_species"] as! [String:Any])["name"] as! String
                return self.filterTypes.contains(name)
        })}
        
        tableView.reloadData()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDexView" {
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


}

