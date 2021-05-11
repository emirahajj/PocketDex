//
//  FavPokemon+CoreDataProperties.swift
//  
//
//  Created by Emira Hajj on 5/10/21.
//
//

import Foundation
import CoreData


extension FavPokemon {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavPokemon> {
        return NSFetchRequest<FavPokemon>(entityName: "FavPokemon")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: Int

}
