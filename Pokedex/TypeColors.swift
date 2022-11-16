//
//  TypeColors.swift
//  Pokedex
//
//  Created by Isaac Miller on 11/15/22.
//
import UIKit
import Foundation

public enum TypeColors {
    static let normalValue = UIColor(red: 0.67, green: 0.67, blue: 0.51, alpha: 1.00)
    static let fireValue = UIColor(red: 0.93, green: 0.51, blue: 0.25, alpha: 1.00)
    static let waterValue = UIColor(red: 0.25, green: 0.51, blue: 0.93, alpha: 1.00)
    static let electricValue = UIColor(red: 0.93, green: 0.93, blue: 0.25, alpha: 1.00)
    static let grassValue = UIColor(red: 0.29, green: 0.81, blue: 0.64, alpha: 1.00)
    static let iceValue = UIColor(red: 0.51, green: 0.93, blue: 0.93, alpha: 1.00)
    static let fightingValue = UIColor(red: 0.93, green: 0.25, blue: 0.25, alpha: 1.00)
    static let poisonValue = UIColor(red: 0.67, green: 0.25, blue: 0.67, alpha: 1.00)
    static let groundValue = UIColor(red: 0.93, green: 0.67, blue: 0.25, alpha: 1.00)
    static let flyingValue = UIColor(red: 0.67, green: 0.67, blue: 0.93, alpha: 1.00)
    static let psychicValue = UIColor(red: 0.93, green: 0.25, blue: 0.93, alpha: 1.00)
    static let bugValue = UIColor(red: 0.67, green: 0.67, blue: 0.25, alpha: 1.00)
    static let rockValue = UIColor(red: 0.67, green: 0.51, blue: 0.25, alpha: 1.00)
    static let ghostValue = UIColor(red: 0.25, green: 0.25, blue: 0.67, alpha: 1.00)
    static let dragonValue = UIColor(red: 0.25, green: 0.25, blue: 0.93, alpha: 1.00)
    static let darkValue = UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.00)
    static let steelValue = UIColor(red: 0.67, green: 0.67, blue: 0.67, alpha: 1.00)
    static let fairyValue = UIColor(red: 0.93, green: 0.67, blue: 0.93, alpha: 1.00)
    

    static func getColor(type: String) -> UIColor {
        switch type {
        case "normal":
            return TypeColors.normalValue
        case "fire":
            return TypeColors.fireValue
        case "water":
            return TypeColors.waterValue
        case "electric":
            return TypeColors.electricValue
        case "grass":
            return TypeColors.grassValue
        case "ice":
            return TypeColors.iceValue
        case "fighting":
            return TypeColors.fightingValue
        case "poison":
            return TypeColors.poisonValue
        case "ground":
            return TypeColors.groundValue
        case "flying":
            return TypeColors.flyingValue
        case "psychic":
            return TypeColors.psychicValue
        case "bug":
            return TypeColors.bugValue
        case "rock":
            return TypeColors.rockValue
        case "ghost":
            return TypeColors.ghostValue
        case "dragon":
            return TypeColors.dragonValue
        case "dark":
            return TypeColors.darkValue
        case "steel":
            return TypeColors.steelValue
        case "fairy":
            return TypeColors.fairyValue
        default:
            return .gray
        }
    }
}
