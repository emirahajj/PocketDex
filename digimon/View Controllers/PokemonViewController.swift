//
//  ViewController.swift
//  digimon
//
//  Created by Emira Hajj on 2/4/21.
//

import UIKit
import AlamofireImage
import AYPopupPickerView


class PokemonViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    
    var myPic = String()

    
    let typeColors = [
        "normal" : UIColor(red: 0.6588, green: 0.6588, blue: 0.4902, alpha: 1.0) /* #a8a87d */,
        "fighting" : UIColor(red: 0.6941, green: 0.2392, blue: 0.1922, alpha: 1.0) /* #b13d31 */,
        "flying" : UIColor(red: 0.6431, green: 0.5686, blue: 0.9176, alpha: 1.0) /* #a491ea */,
        "poison" : UIColor(red: 0.5804, green: 0.2745, blue: 0.6078, alpha: 1.0) /* #94469b */,
        "ground" : UIColor(red: 0.8588, green: 0.7569, blue: 0.4588, alpha: 1.0) /* #dbc175 */,
        "rock" : UIColor(red: 0.7059, green: 0.6314, blue: 0.2941, alpha: 1.0) /* #b4a14b */,
        "bug" : UIColor(red: 0.6706, green: 0.7176, blue: 0.2588, alpha: 1.0) /* #abb742 */,
        "ghost" : UIColor(red: 0.4235, green: 0.349, blue: 0.5804, alpha: 1.0) /* #6c5994 */,
        "steel" : UIColor(red: 0.7216, green: 0.7216, blue: 0.8078, alpha: 1.0) /* #b8b8ce */,
        "fire" : UIColor(red: 0.8824, green: 0.5255, blue: 0.2667, alpha: 1.0) /* #e18644 */,
        "water" : UIColor(red: 0.4392, green: 0.5608, blue: 0.9137, alpha: 1.0) /* #708fe9 */,
        "grass" : UIColor(red: 0.5451, green: 0.7765, blue: 0.3765, alpha: 1.0) /* #8bc660 */,
        "electric" : UIColor(red: 0.9451, green: 0.8196, blue: 0.3294, alpha: 1.0) /* #f1d154 */,
        "psychic" : UIColor(red: 0.902, green: 0.3882, blue: 0.5333, alpha: 1.0) /* #e66388 */,
        "ice" : UIColor(red: 0.651, green: 0.8392, blue: 0.8431, alpha: 1.0) /* #a6d6d7 */,
        "dragon" : UIColor(red: 0.4118, green: 0.2314, blue: 0.9373, alpha: 1.0) /* #693bef */,
        "dark" : UIColor(red: 0.4235, green: 0.349, blue: 0.2902, alpha: 1.0) /* #6c594a */,
        "fairy" : UIColor(red: 0.8863, green: 0.6157, blue: 0.6745, alpha: 1.0) /* #e29dac */,
    ]
    var pokemon = [[String:Any]]() //dictionary that stores URL + pokemon names
    @IBOutlet weak var tableView: UITableView!
    var picString = String()
        
    let popUp = AYPopupPickerView()
    let gens = ["Gen I", "Gen II", "Gen III", "Gen IV", "Gen V", "Gen VI", "Gen VII"]
    let genLookup = [
        "Gen I" : "https://pokeapi.co/api/v2/pokemon?limit=151&offset=0",
        "Gen II" : "https://pokeapi.co/api/v2/pokemon?limit=100&offset=152",
        "Gen III" : "https://pokeapi.co/api/v2/pokemon?limit=202&offset=251"
        
    ]
    
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
                
                self.pokemon = dataDictionary["results"] as! [[String:Any]]
                self.tableView.setContentOffset(.zero, animated: true)
                self.tableView.reloadData()
            }
        }
        task.resume()
        
    }
    
    
    @IBOutlet weak var btn: UIButton!
    
    @IBAction func toggleGen(_ sender: Any) {
        var gen = String()
        popUp.display(itemTitles: gens, doneHandler: {
                        let selectedIndex = self.popUp.pickerView.selectedRow(inComponent: 0);
                        gen = self.gens[selectedIndex];
                        self.APIcall(genString: gen)
                        self.btn.setTitle(self.gens[selectedIndex], for: .normal)})

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        popUp.pickerView.dataSource = self
        popUp.pickerView.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=151&offset=0")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                self.pokemon = dataDictionary["results"] as! [[String:Any]]
                
                self.tableView.reloadData()
            }
        }
        task.resume()

        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemon.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gens.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gens[row]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell = tableView.dequeueReusableCell(withIdentifier: "PokeCell") as! PokeCell
        
        let mypoke = pokemon[indexPath.row]
        let name = mypoke["name"] as! String //name of pokemon
        let myURL = mypoke["url"] as! String // url like .../v2/pokemon/<number>/
        let number = Int(myURL.dropFirst(34).dropLast())!
        let picstring = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(number).png"
        let photoURL = URL(string: picstring)
        cell.digiPic.af.setImage(withURL: photoURL!)
        
        var strlevel = String(number)
        if (number < 10) {
            strlevel = "00\(strlevel)"
        } else if (number >= 10 && number < 100){
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("i got called")
        

        //ensuring the sender is the type of cell we want
        let cell = sender as! PokeCell

        //getting the index of that tapped cell
        let index = tableView.indexPath(for: cell)!
                
        //the url for the pokemon information--remmeber this is just the name +
        let pokeURL = pokemon[index.row]["url"] as! String

        //create a variable that represents the viewcontroller we cwant to navigate to
        let dexViewController = segue.destination as! DexEntryController
        
        //need to pass image and url for API call to the next screen
        dexViewController.pokeURL = pokeURL
        dexViewController.picString = cell.myPic!
        dexViewController.formattedName = cell.properName!
        dexViewController.id = cell.digiLevel.text!
        
    
    }


}

