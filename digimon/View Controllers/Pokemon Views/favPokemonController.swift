//
//  favPokemonController.swift
//  digimon
//
//  Created by Emira Hajj on 5/10/21.
//

import UIKit
import Alamofire
import CoreData

class favPokemonController: UIViewController, UITableViewDelegate, UITableViewDataSource, ViewStyle {
    
    func styleController(frame: CGRect) {
        let GradientColors = dictionary.mainPokemonColors
        view.createGradientLayer(frame: frame, colors: GradientColors)
    }
    

    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var models = [FavPokemon]()
    @IBOutlet weak var favtableView: UITableView!
    let dictionary = dict.init()
    
    
    override func viewDidAppear(_ animated: Bool) {
        getAllFavs()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        favtableView.delegate = self
        favtableView.dataSource = self
        styleController(frame: view.frame)
        //createFav(_name: "Bulbasair", _id: 001)

        // Do any additional setup after loading the view.
    }
    
    
    func getAllFavs() {
        do {
            models = try context.fetch(FavPokemon.fetchRequest())
            DispatchQueue.main.async {
                self.favtableView.reloadData()
            }
        } catch {
            print("nice try")
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokeCell") as! PokeCell
        cell.digiName.text = model.name
        let picstring = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(model.id).png"
        let photoURL = URL(string: picstring)
        cell.digiPic.af.setImage(withURL: photoURL!)
        cell.digiPic.layer.magnificationFilter = CALayerContentsFilter.nearest
        cell.digiLevel.text = String(model.id)
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
