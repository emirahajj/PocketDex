//
//  DexEntryController.swift
//  digimon
//
//  Created by Emira Hajj on 2/12/21.
//

import UIKit
import Alamofire
import CoreData

class DexEntryController: UIViewController, ViewStyle, UITableViewDelegate, UITableViewDataSource {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var models = [FavPokemon]()
    
    let APImanager = APIHelper()
    let typeColors = dict.init().typeColors
    let dictionary = dict.init()
    let defaults = UserDefaults.standard
    var type = String()
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let moveTriggers = ["level-up", "machine", "tutor"]
    
    var pokeURL : String! //https://pokeapi.co/api/v2/pokemon/<name>/ endpoint
    var dexInfo = [String: Any]() //stores the JSON from above response
    var formattedName = String() //capitalized pokemon name
    var speciesInfo = [String: Any]() //dictionary that holds species info
    var picString : String!
    var id = String()
    var evoChainURL = String()
    var totalMoveSet = [[String:Any]]()
    var filteredMoveSet = [[String:Any]]()
    var moveCriteria = "level-up"
    let colors = dict.init().DexEntryColors
    var textEntries = [[String:Any]]()
    var dexText = String()
    var statsArray = [[String:Any]]()



    @IBOutlet weak var statsTable: UITableView!
    
    //top view
    @IBOutlet weak var topColor: UIView! //top view that holds pokemon, pokeball image, and pokedex #
    @IBOutlet weak var pokeBall: UIImageView!
    @IBOutlet weak var dexEntryLabel: UILabel! //pokedex entry number
    @IBOutlet weak var dexPicture: UIImageView! //main pokemon image
    

    
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var pokemonNameLabel: UILabel! //pokemon name

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var secondaryStack: UIStackView!
    
    @IBOutlet weak var dexTextLabel: UILabel!
    @IBOutlet weak var favIcon: UIButton!
    
//    override func viewWillLayoutSubviews() {
//        super.updateViewConstraints()
//        self.tableViewHeight?.constant = self.tableView.contentSize.height
//        self.viewHeight?.constant = self.scrollView.contentSize.height
//
//        print("viewHeight ", self.viewHeight?.constant)
//        print("contentSize: ", self.scrollView.contentSize.height)
//    }
    
    
    func createFav(_name: String, _id: Int) {
        let newPokemon = FavPokemon(context: context)
        newPokemon.name = _name
        newPokemon.id = Int64(_id)
        
        do {
            try context.save()
            //getAllFavs()
            
        } catch {
            print("couldn't save!")
        }
    }
    
    func deleteFav(item: FavPokemon) {
        
        context.delete(item)
        do {
            try context.save()
            
        } catch {
            print("couldn't save!")
        }
    }
    
    @IBAction func showMoves(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let myAlert = storyboard.instantiateViewController(withIdentifier: "moves") as? MoveController {
            myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            myAlert.totalMoveSet = totalMoveSet
            myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            self.present(myAlert, animated: true, completion: nil)
        
        }
        
    }
    func exists(name: String) -> [FavPokemon] {
        let fetchOne = NSFetchRequest<FavPokemon>(entityName: "FavPokemon")
        fetchOne.fetchLimit = 1
        fetchOne.predicate = NSPredicate(format: "name == %@", name)
        var count = [FavPokemon]()
        
        do {
            count = try context.fetch(fetchOne)
        } catch let error as NSError{
            print("Couldn't fetch. \(error)")
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = statsTable.dequeueReusableCell(withIdentifier: "statCell") as! StatsCell
        let statObj = statsArray[indexPath.row]
        
        cell.statLabel.text = (statObj["stat"] as! [String:Any])["name"] as! String
        cell.amountVal = statObj["base_stat"] as! Double
        cell.amtLabel.text = String(cell.amountVal)
        
        cell.progressBar.progressTintColor = self.typeColors[type]!
        UIView.animate(withDuration: 0.5, delay: 6.5, options: .curveEaseInOut){
            cell.progressBar.setProgress(Float(cell.amountVal/255), animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    @IBAction func addFav(_ sender: Any) {
        if exists(name: formattedName).count > 0{
            //if it's already favorited, delete it and hollow out the button
            let itemToDelete = exists(name: formattedName)
            favIcon.setImage(UIImage(systemName: "star"), for: .normal)
            //how to delete tho?
            deleteFav(item: itemToDelete[0])
        }
        else {
            //its not a favorite, create a fav then fill in the button
            favIcon.setImage(UIImage(systemName: "star.fill"), for: .normal)
            createFav(_name: formattedName, _id: Int(id)!)
        }
        
    }
    
    func filterText() {
        for flavor in textEntries {
            let version = (flavor["version"] as! [String:Any])["name"] as! String
            let language = (flavor["language"] as! [String:Any])["name"] as! String
            let version_group = defaults.object(forKey: "versionGroup") as! String
            if dictionary.gameVersion2VersionGroup[version_group]!.contains(version) && language == "en"{
                print(flavor)
                dexTextLabel.text = (flavor["flavor_text"] as! String).replacingOccurrences(of: "\n", with: " ")
                return
            }
        }

    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statsTable.delegate = self
        statsTable.dataSource = self
        //exists(name: formattedName)
        
        styleController(frame: view.frame)
        //set the image
        let url = URL(string: picString)!
        dexPicture.af.setImage(withURL: url)
        dexPicture.layer.magnificationFilter = CALayerContentsFilter.nearest

        dexPicture.layer.shadowColor = UIColor.darkGray.cgColor
        dexPicture.layer.shadowRadius = 7
        dexPicture.layer.shadowOpacity = 1
        dexPicture.layer.shadowOffset = CGSize.init(width: 0, height: 7)
        topColor.layer.cornerRadius = 12
        pokeBall.layer.opacity = 0.3
        pokeBall.transform = pokeBall.transform.rotated(by: 3.14/6)
        
        topColor.layer.shadowColor = UIColor.darkGray.cgColor
        topColor.layer.shadowRadius = 7
        topColor.layer.shadowOpacity = 1
        topColor.layer.shadowOffset = CGSize.init(width: 0, height: 7)
        
        
        
        if exists(name: formattedName).count > 0 {
            favIcon.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        
        //first API call to get the stats in the progress bars
        APImanager.APICall(pokeURL) {theResponse in
            
            //extract pokemon type and format button
            let types = (((theResponse["types"] as! NSArray)[0] as! [String:Any])["type"] as! [String:Any])
            self.type = types["name"] as! String
            self.typeButton.buttonStyle(self.type)
            self.topColor.backgroundColor = self.typeColors[self.type]

            
            //setting the number
            self.dexEntryLabel.text = "#" + self.id

            //Setting + formatting name
            self.pokemonNameLabel.text = self.formattedName


            //stats/status bar formatting formatting
            let statArr = (theResponse["stats"] as! [[String:Any]])
            self.statsArray = theResponse["stats"] as! [[String:Any]]
            self.statsTable.reloadData()
            

            //setting all the moves a pokemon can learn
            self.totalMoveSet = theResponse["moves"] as! [[String:Any]]

            //self.tableViewHeight.constant = self.tableView.contentSize.height
            //self.viewHeight.constant = self.scrollView.contentSize.height + self.tableViewHeight.constant
            

        
        }
        
        let pokeID = pokeURL.dropFirst(34).dropLast()
        let speciesURL = "https://pokeapi.co/api/v2/pokemon-species/\(pokeID)/"
        
        //calls the species URL to get the evolution chain, stats, etc
        APImanager.APICall(speciesURL) {theResponse in
            self.evoChainURL = (theResponse["evolution_chain"] as! [String:Any])["url"] as! String
            
            self.textEntries = theResponse["flavor_text_entries"] as! [[String:Any]]
            self.filterText()

            
            self.getEvoChain(self.evoChainURL)
            
        }
    }

    //creates a view given a species object to add to the stackView for the evolution chain
    func createEvoContainerView(obj: NSObject) -> UIView {
        //object we're passing is "species." it has "name" and "url" keys
        
        let pokeName = obj.value(forKey: "name") as! String
        let num = (obj.value(forKey: "url") as! String).dropFirst(42).dropLast()
        
        //inner stackView creation + styling
        let firstContainerView = UIStackView()
        firstContainerView.translatesAutoresizingMaskIntoConstraints = false;
        firstContainerView.distribution = .equalSpacing
        firstContainerView.alignment = .center
        firstContainerView.axis
            = .vertical
        
        //view.addSubview(firstContainerView)
        firstContainerView.translatesAutoresizingMaskIntoConstraints = false;
        firstContainerView.frame = CGRect(x: 0, y: 0, width: 110, height: 110)
        firstContainerView.widthAnchor.constraint(equalToConstant: 110).isActive = true
        firstContainerView.heightAnchor.constraint(equalToConstant: 110).isActive = true
        //firstContainerView.layer.borderColor = UIColor.black.cgColor
        //firstContainerView.layer.borderWidth = 1
        //firstContainerView.layer.backgroundColor = UIColor.brown.cgColor
        
        //label creation + styling
        let label = UILabel()
        label.text = pokeName.capitalized
        label.sizeToFit()
//        label.font = UIFont(name: "System-Black", size: 14.0)
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .heavy)

        
        //label.frame = CGRect(x:0, y:0, width: 100, height: 20)
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        label.textColor = UIColor.white
        label.textAlignment = .center

        //image creation + styling
        let firstImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 75, height: 75))
        let urls = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-vii/icons/\(num).png"
        let url = URL(string: urls)!
        firstImage.af.setImage(withURL: url)
        firstImage.layer.magnificationFilter = CALayerContentsFilter.nearest

        firstImage.contentMode = .scaleAspectFit
        firstImage.layer.shadowColor = UIColor.darkGray.cgColor
        firstImage.layer.shadowRadius = 7
        firstImage.layer.shadowOpacity = 1
        firstImage.layer.shadowOffset = CGSize.init(width: 0, height: 7)
        //firstImage.layer.backgroundColor = UIColor.red.cgColor
        firstImage.widthAnchor.constraint(equalToConstant: 75).isActive = true
        firstImage.heightAnchor.constraint(equalToConstant: 75).isActive = true
        //adding to view
        firstContainerView.addArrangedSubview(firstImage)
        firstContainerView.addArrangedSubview(label)
        
        return firstContainerView
    }
    
    
    func getEvoChain(_ url : String){
        stackView.translatesAutoresizingMaskIntoConstraints = false;
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.axis = .horizontal
        

        print(url)
        self.APImanager.APICall(url) {evoResponse in
            
            let species = (evoResponse["chain"] as! [String:Any])["species"] as! [String:Any]
            
            let newView = self.createEvoContainerView(obj: species as NSObject)
            let bottom = self.createEvoContainerView(obj: species as NSObject)

//            let newView1 = self.createEvoContainerView(obj: species as NSObject)
//            let newView2 = self.createEvoContainerView(obj: species as NSObject)

            let first_array = (evoResponse["chain"] as! [String:Any])["evolves_to"] as! [[String:Any]]
            print(first_array)
            
            self.stackView.addArrangedSubview(newView)
            //self.secondaryStack.addArrangedSubview(bottom)

            
            for index in 0..<first_array.count{
                //catches the following cases:
                //line of two, line of three, evolves once, then branches to two
                if first_array.count == 1 {
                    let next_obj = first_array[0]
                    //get the inner species and evolves_to array
                    let next_species = next_obj["species"] as! [String:Any]
                    let next_view = self.createEvoContainerView(obj: next_species as NSObject)

                    
                    //adds second pokemon
                    self.stackView.addArrangedSubview(next_view)
                    //self.secondaryStack.addArrangedSubview(next_view2)
                    
                    let next_array = next_obj["evolves_to"] as! [[String:Any]]
                    if next_array.count == 1 {
                        //create a new stack view here but make it vertical //220 high and 110 wide
                        
                        let further_object = next_array[0]
                        let further_species = further_object["species"] as! [String:Any]
                        let further_view = self.createEvoContainerView(obj: further_species as NSObject)
//                        let further_view2 = self.createEvoContainerView(obj: further_species as NSObject)
                        
                        self.stackView.addArrangedSubview(further_view)
                        //when it evolves once then it branches
                    } else if next_array.count == 2 {
                        
                        let further_object1 = next_array[0]
                        let further_species1 = further_object1["species"] as! [String:Any]
                        let further_view1 = self.createEvoContainerView(obj: further_species1 as NSObject)


                        let further_object2 = next_array[1]
                        let further_species2 = further_object2["species"] as! [String:Any]
                        let further_view2 = self.createEvoContainerView(obj: further_species2 as NSObject)

                        let innerStack = UIStackView()
                        innerStack.translatesAutoresizingMaskIntoConstraints = false;
                        innerStack.distribution = .fillEqually
                        innerStack.alignment = .center
                        innerStack.axis = .vertical
                        
                        innerStack.frame = CGRect(x: 0, y: 0, width: 110, height: 220)
                        innerStack.widthAnchor.constraint(equalToConstant: 110).isActive = true
                        innerStack.heightAnchor.constraint(equalToConstant: 220).isActive = true
                        
                        innerStack.addArrangedSubview(further_view1)
                        innerStack.addArrangedSubview(further_view2)
                        
                        self.stackView.addArrangedSubview(innerStack)
                    }
                }

            }

            
            
        }
    }
    
    func styleController(frame: CGRect) {
        let GradientColors = dictionary.DexEntryColors
        view.createGradientLayer(frame: frame, colors: GradientColors)
    }
    
}
