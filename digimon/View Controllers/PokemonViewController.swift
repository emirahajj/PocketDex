//
//  ViewController.swift
//  digimon
//
//  Created by Emira Hajj on 2/4/21.
//

import UIKit
import AlamofireImage
import AYPopupPickerView


class PokemonViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UISearchBarDelegate {

    
    var isMenuActive = false
    var myPic = String()

    var pokemon = [[String:Any]]() //dictionary that stores URL + pokemon names
    
    var secondary = [[String:Any]]() //duplicate of pokemon to use search feature
    
    var picString = String() //string representing pokemon image

    @IBOutlet weak var pokeContent: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var tableView: UITableView! //for pokemon
    @IBOutlet weak var searchBar: UISearchBar!
    
    let popUp = AYPopupPickerView()
    let gens = ["R/B/Y", "G/S/C", "R/S/E", "D/P", "Plat.", "HG/SS", "B/W", "B2/W2"]
    
    let version_groups = ["red-blue", "yellow", "gold-silver", "crystal", "ruby-sapphire", "emerald", "firered-leafgreen", "diamond-pearl", "platinum", "heartgold-soulsilver", "black-white", "black-2-white-2" , "x-y", "omega-ruby-alpha-sapphire", "sun-moon", "ultra-sun-ultra-moon"]
    
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
    
    let typesArray = ["normal", "fighting", "flying", "poison", "ground", "rock", "bug", "ghost", "steel", "fire", "water", "grass", "electric", "psychic", "ice", "dragon", "dark", "fairy", "unknown", "shadow"]
    
    func APIcall(genString: String) {
        let genInfo = genLookup[genString]! as String
        
        let url = URL(string: genInfo)!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                self.secondary = dataDictionary["pokemon_entries"] as! [[String:Any]]
                self.pokemon = dataDictionary["pokemon_entries"] as! [[String:Any]]
                self.tableView.setContentOffset(.zero, animated: true)
                self.tableView.reloadData()
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
    
    @IBOutlet weak var btn: UIButton!
    
    @IBAction func toggleGen(_ sender: Any) {
        var gen = String()
        popUp.headerView.backgroundColor = UIColor.blue
        popUp.pickerView.backgroundColor = UIColor.white
        let blureffect = UIBlurEffect(style: .light)
        let blurview = UIVisualEffectView(effect: blureffect)
        blurview.frame = popUp.pickerView.bounds
        popUp.pickerView.insertSubview(blurview, at: 0)
//        popUp.pickerView.sendSubviewToBack(blurview)
        popUp.display(itemTitles: gens, doneHandler: {
                        let selectedIndex = self.popUp.pickerView.selectedRow(inComponent: 0);
                        gen = self.gens[selectedIndex];
                        self.APIcall(genString: gen)})

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.layoutIfNeeded()
        
        let rect = CGRect(x: 0, y: 0, width: view.layer.bounds.width/3, height: view.layer.bounds.width)
        let newView = UIView(frame:rect)
        newView.backgroundColor = UIColor.cyan.withAlphaComponent(0.3)
        newView.translatesAutoresizingMaskIntoConstraints = false
        


        view.addSubview(newView)
        view.sendSubviewToBack(newView)
        
        newView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        newView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        newView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        newView.trailingAnchor.constraint(equalTo: pokeContent.leadingAnchor).isActive = true
        newView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true


    
        
        let frost = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        frost.frame = (self.tabBarController?.tabBar.bounds)!
        self.tabBarController?.tabBar.insertSubview(frost, at: 0)
        
        self.title = "PocketDex"
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true

        popUp.pickerView.dataSource = self
        popUp.pickerView.delegate = self
        
        searchBar.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let blue = UIColor(red: 0.62, green: 0.28, blue: 0.76, alpha: 1.00)
        let green = UIColor(red: 0.27, green: 0.64, blue: 0.84, alpha: 1.00)
        let array = [blue.cgColor, green.cgColor]
        pokeContent.layer.insertSublayer(gradient(frame: view.bounds, colors:array ), at:0)
        view.layer.insertSublayer(gradient(frame: view.bounds, colors:array ), at:0)

        
//        searchBar.layer.backgroundColor = UIColor.clear.cgColor
        searchBar.searchBarStyle = .minimal
        searchBar.setBackgroundImage(UIImage(ciImage: .white), for: UIBarPosition(rawValue: 0)!, barMetrics:.default)
        searchBar.searchTextField.attributedPlaceholder =  NSAttributedString.init(string: "Search Pokémon", attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray])
        
                
        // Do any additional setup after loading the view.
        let url = URL(string: "https://pokeapi.co/api/v2/pokedex/2/")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return secondary.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //secondary = []
        if searchText == "" {
            secondary = pokemon
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
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokeCell") as! PokeCell
        
        let mypoke = secondary[indexPath.row]
        let name = (mypoke["pokemon_species"] as! [String:Any])["name"] as! String //name of pokemon
        let myURL = (mypoke["pokemon_species"] as! [String:Any])["url"] as! String
//            mypoke["url"] as! String // url like .../v2/pokemon/<number>/
        let number = Int(myURL.dropFirst(42).dropLast())!
        let localDexNumber = mypoke["entry_number"] as! Int
        print(number)
        let picstring = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(number).png"
        let photoURL = URL(string: picstring)
        cell.digiPic.af.setImage(withURL: photoURL!)
        
        var strlevel = String(localDexNumber)
        if (localDexNumber < 10) {
            strlevel = "00\(strlevel)"
        } else if (localDexNumber >= 10 && localDexNumber < 100){
            strlevel = "0\(strlevel)"
        }
        cell.digiLevel.text = strlevel

        //capitalizing first letter since its all lowercase
        let properName = name.prefix(1).uppercased() + name.lowercased().dropFirst()
        cell.properName = properName
        cell.digiName.text = properName
        cell.myPic = picstring
        return cell
    }
    
    @IBAction func buttonTap(_ sender: Any) {

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
            self.pokeContent.frame.origin.x = self.isMenuActive ? 0 : self.pokeContent.frame.width - (self.pokeContent.frame.width * 0.6)
        } completion: { (finished) in
            print("hi")
            self.isMenuActive.toggle()
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("i got called")
        

        //ensuring the sender is the type of cell we want
        let cell = sender as! PokeCell

        //getting the index of that tapped cell
        let index = tableView.indexPath(for: cell)!
                
        //the url for the pokemon information--remmeber this is just the name +
        //print(pokemon[index.row])
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

