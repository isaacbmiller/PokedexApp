//
//  PokemonData + GetColor.swift
//  Pokedex
//
//  Created by Isaac Miller on 11/15/22.
//

import Foundation
import SwiftUI

extension Pokemon {
    var typeColor: UIColor {
        get {
            TypeColors.getColor(type: self.types[0].type.name)
        }
    }
}
