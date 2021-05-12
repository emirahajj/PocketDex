//
//  DexEntryController.swift
//  digimon
//
//  Created by Emira Hajj on 2/12/21.
//

import UIKit
import Alamofire
import CoreData

extension UIProgressView{

    override open func awakeFromNib() {
        super.awakeFromNib()
        changeStyles()
    }
    func changeStyles(){
        self.transform = CGAffineTransform(scaleX: 1, y: 2)
        self.layer.cornerRadius = 5
        self.layer.sublayers![1].cornerRadius = 5
        self.clipsToBounds = true
        self.subviews[1].clipsToBounds = true
        self.trackTintColor = UIColor.darkGray.withAlphaComponent(0.4)
    }
}

class DexEntryController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var models = [FavPokemon]()


    let pokemonColors = dict.init().colors
    let typeColors = dict.init().typeColors
    
    //I want it to display: pokemon name, evolution (+ levels), moveset
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let moveTriggers = ["level-up", "machine", "tutor"]
    
    var pokeURL : String! //https://pokeapi.co/api/v2/pokemon/<name>/ endpoint
    var dexInfo = [String: Any]() //stores the JSON from above response
    
    var picInfo = [String: Any]()
    var formattedName = String() //capitalized pokemon name
    var speciesInfo = [String: Any]() //dictionary that holds species info
    var picString : String!
    var id = String()
    var evoChainURL = String()
    var totalMoveSet = [[String:Any]]()
    var filteredMoveSet = [[String:Any]]()
    var moveCriteria = "level-up"


    
    //top view
    @IBOutlet weak var topColor: UIView! //top view that holds pokemon, pokeball image, and pokedex #
    @IBOutlet weak var pokeBall: UIImageView!
    @IBOutlet weak var dexEntryLabel: UILabel! //pokedex entry number
    @IBOutlet weak var dexPicture: UIImageView! //main pokemon image
    @IBOutlet weak var moveSegment: UISegmentedControl!
    
    //stat bars
    @IBOutlet weak var speedBar: UIProgressView!
    @IBOutlet weak var spDefBar: UIProgressView!
    @IBOutlet weak var spAtkBar: UIProgressView!
    @IBOutlet weak var defenseBar: UIProgressView!
    @IBOutlet weak var attackBar: UIProgressView!
    @IBOutlet weak var hpBar: UIProgressView!
    
    @IBOutlet weak var hpAmount: UILabel!
    @IBOutlet weak var spAttkAmt: UILabel!
    @IBOutlet weak var defAmount: UILabel!
    @IBOutlet weak var attackAmount: UILabel!
    @IBOutlet weak var speedAmt: UILabel!
    @IBOutlet weak var spDefAmt: UILabel!
    
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var pokemonNameLabel: UILabel! //pokemon name
    @IBOutlet weak var hpLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var secondaryStack: UIStackView!
    
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var favIcon: UIButton!
    //@IBOutlet weak var scrollView: UIScrollView!
    
    
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
            layer.startPoint = CGPoint(x: 0, y: 0.5)
            layer.endPoint = CGPoint(x: 0.5, y: 0)
            layer.colors = colors
            return layer
        }
    
    //param: lowercase string representing pokemon type
    func buttonStyle(_ a : String){
        let capType = a.prefix(1).uppercased() + a.lowercased().dropFirst()
        self.typeButton.titleLabel?.text = capType
        self.typeButton.setTitle(capType, for: .normal)
        
        self.typeButton.backgroundColor = typeColors[a]
        self.typeButton.layer.cornerRadius = 8
        self.typeButton.titleLabel?.layer.shadowColor = UIColor.black.cgColor
        self.typeButton.titleLabel?.layer.shadowOffset = CGSize(width: -0.15, height: 0.5)
        self.typeButton.titleLabel!.layer.shadowOpacity = 1.0
    }
    
    func filterMoves() {
        filteredMoveSet = totalMoveSet.filter{object in
            let version_details = object["version_group_details"] as! [[String:Any]]
            for obj in version_details {
                if let version_group_obj = (obj["move_learn_method"] as! [String: Any])["name"]{
                    return version_group_obj as! String == moveCriteria
                }
            }
            return false
        }
        tableView.reloadData()
        
    }
    
    @IBAction func segTap(_ sender: Any) {
        moveCriteria = moveTriggers[moveSegment.selectedSegmentIndex]
        print(moveTriggers[moveSegment.selectedSegmentIndex])
        filterMoves()
        tableView.reloadData()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exists(name: formattedName)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        let blue = UIColor(red: 0.62, green: 0.28, blue: 0.76, alpha: 1.00)
        let green = UIColor(red: 0.27, green: 0.64, blue: 0.84, alpha: 1.00)
        let array = [blue.cgColor, green.cgColor]
        view.layer.insertSublayer(gradient(frame: view.bounds, colors:array ), at:0)
        
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
        APICall(pokeURL) {theResponse in
            
            //extract pokemon type and format button
            let types = (((theResponse["types"] as! NSArray)[0] as! [String:Any])["type"] as! [String:Any])
            let type = types["name"] as! String
            self.buttonStyle(type)
            
            //setting the number
            self.dexEntryLabel.text = "#" + self.id

            //Setting + formatting name
            self.pokemonNameLabel.text = self.formattedName


            //stats/status bar formatting formatting
            let statArr = (theResponse["stats"] as! [[String:Any]])
            let hp = ((statArr[0] as [String:Any])["base_stat"] as! Double)
            self.hpAmount.text = String(Int(hp))
            let attack = ((statArr[1] as [String:Any])["base_stat"] as! Double)
            self.attackAmount.text = String(Int(attack))
            let defense = ((statArr[2] as [String:Any])["base_stat"] as! Double)
            self.defAmount.text = String(Int(defense))
            let spAtk = ((statArr[3] as [String:Any])["base_stat"] as! Double)
            self.spAttkAmt.text = String(Int(spAtk))
            let spDef = ((statArr[4] as [String:Any])["base_stat"] as! Double)
            self.spDefAmt.text = String(Int(spDef))
            let speed = ((statArr[5] as [String:Any])["base_stat"] as! Double)
            self.speedAmt.text = String(Int(speed))
            
            //print("before reload", self.viewHeight)
            
            //setting all the moves a pokemon can learn
            self.totalMoveSet = theResponse["moves"] as! [[String:Any]]
            self.filterMoves()
            self.tableView.reloadData()

            //self.tableViewHeight.constant = self.tableView.contentSize.height
            //self.viewHeight.constant = self.scrollView.contentSize.height + self.tableViewHeight.constant
            

            
            UIView.animate(withDuration: 0.5, delay: 6.5, options: .curveEaseInOut){
                self.hpBar.setProgress(Float(hp/255), animated: true)
                self.defenseBar.setProgress(Float(defense/255), animated: true)
                self.attackBar.setProgress(Float(attack/255), animated: true)
                self.spAtkBar.setProgress(Float(spAtk/255), animated: true)
                self.spDefBar.setProgress(Float(spDef/255), animated: true)
                self.speedBar.setProgress(Float(speed/255), animated: true)
            }
        }
        
        let pokeID = pokeURL.dropFirst(34).dropLast()
        let speciesURL = "https://pokeapi.co/api/v2/pokemon-species/\(pokeID)/"
        
        //calls the species URL to get the evolution chain, stats, etc
        APICall(speciesURL) {theResponse in
            self.evoChainURL = (theResponse["evolution_chain"] as! [String:Any])["url"] as! String
            
            self.getEvoChain(self.evoChainURL)
            
            let color = (theResponse["color"] as! [String: Any])["name"] as! String
            
            self.topColor.backgroundColor = self.pokemonColors[color]
            self.hpBar.progressTintColor = self.pokemonColors[color]!
            self.attackBar.progressTintColor = self.pokemonColors[color]!
            self.defenseBar.progressTintColor = self.pokemonColors[color]!
            self.spAtkBar.progressTintColor = self.pokemonColors[color]!
            self.spDefBar.progressTintColor = self.pokemonColors[color]!
            self.speedBar.progressTintColor = self.pokemonColors[color]!
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMoveSet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moveCell") as! MoveCell
        cell.moveName.text = ((filteredMoveSet[indexPath.row])["move"] as! [String:Any])["name"] as? String
        return cell
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

//        firstImage.frame =
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
        stackView.axis
            = .horizontal
        

        
        print(url)
        self.APICall(url) {evoResponse in
            
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
                        innerStack.axis
                            = .vertical
                        
                        innerStack.translatesAutoresizingMaskIntoConstraints = false;
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
}
