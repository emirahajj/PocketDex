//
//  Dict.swift
//  digimon
//
//  Created by Emira Hajj on 5/9/21.
//

import Foundation
import UIKit

//struct that will store useful data like defined colors for types and version groups/generations
struct dict {
    //pokemon colors
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
  //colors for pokemon types
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
    //generations
    let gens = ["R/B/Y", "G/S/C", "R/S/E", "D/P", "Plat.", "HG/SS", "B/W", "B2/W2"]
    
    //version groups
    let version_groups = ["red-blue", "yellow", "gold-silver", "crystal", "ruby-sapphire", "emerald", "firered-leafgreen", "diamond-pearl", "platinum", "heartgold-soulsilver", "black-white", "black-2-white-2" , "x-y", "omega-ruby-alpha-sapphire", "sun-moon", "ultra-sun-ultra-moon"]
    
    
    let versionGroupLocationLookup = [
        "red-blue": ["kanto"],
        "yellow": ["kanto"],
        "firered-leafgreen": ["kanto"],
        "gold-silver": ["kanto", "johto"],
        "crystal": ["kanto", "johto"],
        "heartgold-soulsilver": ["kanto", "johto"],
        "ruby-sapphire": ["hoenn"],
        "omega-ruby-alpha-sapphire": ["hoenn"],
        "emerald": ["hoenn"],
        "diamond-pearl": ["sinnoh"],
        "platinum": ["sinnoh"],
        "black-white": ["unova"],
        "black-2-white-2": ["unova"],
        "x-y": ["kalos"],
//        "sun-moon": ["alola"],
//        "ultra-sun-ultra-moon": ["alola"]
    ]
    
    let gameVersion2VersionGroup = [
        "red-blue": ["red", "blue"],
        "yellow": ["yellow"],
        "firered-leafgreen": ["firered", "leafgreen"],
        "gold-silver": ["gold", "silver"],
        "crystal": ["crystal"],
        "heartgold-soulsilver": ["heartgold", "soulsilver"],
        "ruby-sapphire": ["ruby", "sapphire"],
        "omega-ruby-alpha-sapphire": ["omega-ruby", "alpha-sapphire"],
        "emerald": ["emerald"],
        "diamond-pearl": ["diamond", "pearl"],
        "platinum": ["platinum"],
        "black-white": ["black", "white"],
        "black-2-white-2": ["black-2", "white-2"],
        "x-y": ["x", "y"],
    
    ]
    
    //all pokemon types
    let typesArray = ["normal", "fighting", "flying", "poison", "ground", "rock", "bug", "ghost", "steel", "fire", "water", "grass", "electric", "psychic", "ice", "dragon", "dark", "fairy"]
    
    //2D array for side menu content
    let menuContent = [
        ["Gen I", "Gen II", "Gen III", "Gen IV", "Gen V", "Gen VI", "Gen VII"],
        ["red-blue", "yellow", "gold-silver", "crystal", "ruby-sapphire", "emerald", "firered-leafgreen", "diamond-pearl", "platinum", "heartgold-soulsilver", "black-white", "black-2-white-2" , "x-y", "omega-ruby-alpha-sapphire", "sun-moon", "ultra-sun-ultra-moon"],
        ["normal", "fighting", "flying", "poison", "ground", "rock", "bug", "ghost", "steel", "fire", "water", "grass", "electric", "psychic", "ice", "dragon", "dark", "fairy"]]
    
    //section titles for side menu
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
    
    func gradient(frame:CGRect, colors:[CGColor]) -> CAGradientLayer {
            let layer = CAGradientLayer()
            layer.frame = frame
            layer.startPoint = CGPoint(x: 0, y: 1)
            layer.endPoint = CGPoint(x: 0, y: 0)
            layer.colors = colors
            return layer
        }
}
