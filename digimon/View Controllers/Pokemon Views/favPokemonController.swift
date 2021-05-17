//
//  favPokemonController.swift
//  digimon
//
//  Created by Emira Hajj on 5/10/21.
//

import UIKit
import CoreData

class favPokemonController: UIViewController, UITableViewDelegate, UITableViewDataSource, ViewStyle {
    
    func styleController(frame: CGRect) {
        let GradientColors = dictionary.mainPokemonColors
        view.createGradientLayer(frame: frame, colors: GradientColors)
    }
    

    var downloadTask: URLSessionDownloadTask?

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
        let picURL = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(model.id).png"
        
        cell.digiPic.image = UIImage(systemName: "square")
        if let smallURL = URL(string: picURL) {
            downloadTask = cell.digiPic.loadImage(url: smallURL)
        }
        
        
        cell.digiPic.layer.magnificationFilter = CALayerContentsFilter.nearest
        cell.digiLevel.text = String(model.id)
        return cell
    }

}
