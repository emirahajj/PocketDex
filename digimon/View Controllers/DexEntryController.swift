//
//  DexEntryController.swift
//  digimon
//
//  Created by Emira Hajj on 2/12/21.
//

import UIKit
import Alamofire


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
    }
}

class DexEntryController: UIViewController {
    
    //I want it to display: pokemon name, evolution (+ levels), moveset
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let colors = [
        "black": UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)/* #000000 */,
        "blue": UIColor(red: 0.149, green: 0.5216, blue: 0.8275, alpha: 1.0) /* #2685d3 */,
        "brown": UIColor(red: 0.5098, green: 0.2588, blue: 0.0706, alpha: 1.0) /* #824212 */,
        "gray": UIColor(red: 0.6431, green: 0.6471, blue: 0.6471, alpha: 1.0) /* #a4a5a5 */,
        "green": UIColor(red: 0.5137, green: 0.9098, blue: 0.1882, alpha: 1.0) /* #83e830 */,
        "pink": UIColor(red: 0.9765, green: 0.5451, blue: 0.7059, alpha: 1.0) /* #f98bb4 */,
        "purple": UIColor(red: 0.749, green: 0.3294, blue: 0.6157, alpha: 1.0) /* #bf549d */,
        "red": UIColor(red: 0.9882, green: 0.3255, blue: 0.1765, alpha: 1.0) /* #fc532d */,
        "white": UIColor(red: 1, green: 1, blue: 1, alpha: 1.0) /* #ffffff */,
        "yellow": UIColor(red: 0.9569, green: 0.902, blue: 0.2667, alpha: 1.0) /* #f4e644 */
    ]
  
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
    
    var pokeURL : String! //pokemon/<number> endpoint string
    var dexInfo = [String: Any]() //gets the pokemon/1 JSON
    var picInfo = [String: Any]()
    var formattedName = String()
    var speciesInfo = [String: Any]()
    var picString : String!
    var APIcall = String()
    var id = String()
    var evoChainURL = String()
    
    @IBOutlet weak var pokeBall: UIImageView!
    @IBOutlet weak var speedBar: UIProgressView!
    @IBOutlet weak var spDefBar: UIProgressView!
    @IBOutlet weak var spAtkBar: UIProgressView!
    @IBOutlet weak var defenseBar: UIProgressView!
    @IBOutlet weak var attackBar: UIProgressView!
    @IBOutlet weak var hpBar: UIProgressView!
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var topColor: UIView!
    @IBOutlet weak var dexEntryLabel: UILabel!
    @IBOutlet weak var dexPicture: UIImageView!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    //@IBOutlet weak var pokeTypeLabel: UILabel!
    @IBOutlet weak var hpLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    
    func APICall(_ a : String, complete: @escaping ([String:Any])->()) {
        var result = [String:Any]()
        let url1 = URL(string: a)!
        print("URL: \(url1)")
        let request = URLRequest(url: url1, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) {(data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed]) as! [String: Any]
                result = dataDictionary as [String: Any]
                //print("datadictionary: \(self.dexInfo)")
                complete(result)
            }
        }
        task.resume()
    }
    //param: lowercase string representing pokemon type
    func buttonStyle(_ a : String){
        let capType = a.prefix(1).uppercased() + a.lowercased().dropFirst()
        self.typeButton.titleLabel?.text = capType
        self.typeButton.setTitle(capType, for: .normal)
        self.typeButton.backgroundColor = self.typeColors[a]
        self.typeButton.layer.cornerRadius = 8
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height+100)

        
        //set the image
        let url = URL(string: picString)!
        dexPicture.af.setImage(withURL: url)
        topColor.layer.cornerRadius = 12
        //print(dexInfo)
        //pokeBall.image = UIImage(named: "poke.png")
        pokeBall.layer.opacity = 0.3
        pokeBall.transform = pokeBall.transform.rotated(by: 3.14/6)
        
        topColor.layer.shadowRadius = 3.0
        
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
            let attack = ((statArr[1] as [String:Any])["base_stat"] as! Double)
            let defense = ((statArr[2] as [String:Any])["base_stat"] as! Double)
            let spAtk = ((statArr[3] as [String:Any])["base_stat"] as! Double)
            let spDef = ((statArr[4] as [String:Any])["base_stat"] as! Double)
            let speed = ((statArr[5] as [String:Any])["base_stat"] as! Double)

            //self.hpLabel.text = String(hp)
            //self.attackLabel.text = String(attack)
            //self.defenseLabel.text = String(defense)
            
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseInOut){
                self.hpBar.setProgress(Float(hp/255), animated: true)
                self.defenseBar.setProgress(Float(defense/230), animated: true)
                self.attackBar.setProgress(Float(attack/181), animated: true)
                self.spAtkBar.setProgress(Float(spAtk/173), animated: true)
                self.spDefBar.setProgress(Float(spDef/230), animated: true)
                self.speedBar.setProgress(Float(speed/200), animated: true)
            }
        }
        
        //.make api call here instead of in the segue
        let pokeID = pokeURL.dropFirst(34).dropLast()
        //print(pokeID)
        let speciesURL = "https://pokeapi.co/api/v2/pokemon-species/\(pokeID)/"
        
        APICall(speciesURL) {theResponse in
            self.evoChainURL = (theResponse["evolution_chain"] as! [String:Any])["url"] as! String
            
            self.getEvoChain(self.evoChainURL)
            
            let color = (theResponse["color"] as! [String: Any])["name"] as! String
            
            self.topColor.backgroundColor = self.colors[color]
            

            self.hpBar.progressTintColor = self.colors[color]!
            self.attackBar.progressTintColor = self.colors[color]!
            self.defenseBar.progressTintColor = self.colors[color]!
            self.spAtkBar.progressTintColor = self.colors[color]!
            self.spDefBar.progressTintColor = self.colors[color]!
            self.speedBar.progressTintColor = self.colors[color]!
            //self.hpLabel.textColor = self.colors[color]

            self.typeButton.titleLabel?.layer.shadowColor = UIColor.black.cgColor
            self.typeButton.titleLabel?.layer.shadowOffset = CGSize(width: -0.15, height: 0.5)
            self.typeButton.titleLabel!.layer.shadowOpacity = 1.0
            
        }
        
        print(evoChainURL, "hey");

    }
    
    func getEvoChain(_ url : String){
        self.APICall(url) {evoResponse in
            let basePoke = (evoResponse["species"] as! [String: Any])["name"] as! String
            let basePokeNum = ((evoResponse["species"] as! [String: Any])["url"] as! String).dropFirst(42).dropLast()
            
            if ((evoResponse["evolves_to"] as! [[String:Any]]).count == 0){
                //this is the only pokemon
            }
            
        }
    }
    

}
