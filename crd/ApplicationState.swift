//
//  applicationState.swift
//  crd
//
//  Created by Beyer, Zachary on 11/10/16.
//  Copyright © 2016 zbeyer. All rights reserved.
//

import Foundation
import UIKit

//TODO: ZBEYER add save / load to manage multiple cards and persist between usage sessions.

/**
 *  TypeColorIndex enumerated value is used to relate
 *  Color Configuration to a given index...
 */
enum TypeColorIndex: Int {
    case grey = 0
    case red = 1
    case orange = 2
    case yellow = 3
    case green = 4
    case blue = 5
    case indigo = 6
    case violet = 7
}

/**
 *  Generic Singleton Used to Manage the card generator's current
 *  configuration
 */
class ApplicationState {
    static let sharedInstance = ApplicationState()
    public var cardTitle:String=""  //Title of the card
    public var cardLevel:Int = 0    //Generic Attribute Level
    public var cardInfo:String=""   //Body Text
    public var cardType:String=""   //Type or category of card
    public var cardImage:UIImage?   //Background Portrait image
    public var typeColorIndex:TypeColorIndex = .grey
    
    
    public var cardRoll:Int {
        //Generic Attribute computed as 3 times the card's level
        get {
            return self.cardLevel * 3
        }
    }
    
    /**
     *  Computed Property: 
     *  Returnsa the Color Configuration matching typeColorIndex
     */
    public var typeColorForIndex: TypeColor {
        get {
            switch self.typeColorIndex {
            case .grey:
                return TypeColor().newTypeColorFromSclae(c1: UIColor.init(netHex: 0xF5F5F5),
                                                         c2: UIColor.init(netHex: 0xE0E0E0),
                                                         c3: UIColor.init(netHex: 0x9E9E9E),
                                                         c4: UIColor.init(netHex: 0x616161),
                                                         c5: UIColor.init(netHex: 0x212121))
                
            case .red:
                return TypeColor().newTypeColorFromSclae(c1: UIColor.init(netHex: 0xFFCDD2),
                                                         c2: UIColor.init(netHex: 0xE57373),
                                                         c3: UIColor.init(netHex: 0xF44336),
                                                         c4: UIColor.init(netHex: 0xD32F2F),
                                                         c5: UIColor.init(netHex: 0xB71C1C))
                
            case .orange:
                return TypeColor().newTypeColorFromSclae(c1: UIColor.init(netHex: 0xFFE0B2),
                                                         c2: UIColor.init(netHex: 0xFFB74D),
                                                         c3: UIColor.init(netHex: 0xFF9800),
                                                         c4: UIColor.init(netHex: 0xF57C00),
                                                         c5: UIColor.init(netHex: 0xE65100))
            case .yellow:
                return TypeColor().newTypeColorFromSclae(c1: UIColor.init(netHex: 0xFFF9C4),
                                                         c2: UIColor.init(netHex: 0xFFF176),
                                                         c3: UIColor.init(netHex: 0xFFEB3B),
                                                         c4: UIColor.init(netHex: 0xFBC02D),
                                                         c5: UIColor.init(netHex: 0xF57F17))
            case .green:
                return TypeColor().newTypeColorFromSclae(c1: UIColor.init(netHex: 0xC8E6C9),
                                                         c2: UIColor.init(netHex: 0x81C784),
                                                         c3: UIColor.init(netHex: 0x4CAF50),
                                                         c4: UIColor.init(netHex: 0x388E3C),
                                                         c5: UIColor.init(netHex: 0x1B5E20))
            case .blue:
                return TypeColor().newTypeColorFromSclae(c1: UIColor.init(netHex: 0xB3E5FC),
                                                         c2: UIColor.init(netHex: 0x4FC3F7),
                                                         c3: UIColor.init(netHex: 0x03A9F4),
                                                         c4: UIColor.init(netHex: 0x0288D1),
                                                         c5: UIColor.init(netHex: 0x01579B))
            case .indigo:
                return TypeColor().newTypeColorFromSclae(c1: UIColor.init(netHex: 0xC5CAE9),
                                                         c2: UIColor.init(netHex: 0x7986CB),
                                                         c3: UIColor.init(netHex: 0x3F51B5),
                                                         c4: UIColor.init(netHex: 0x303F9F),
                                                         c5: UIColor.init(netHex: 0x1A237E))
            case .violet:
                return TypeColor().newTypeColorFromSclae(c1: UIColor.init(netHex: 0xE1BEE7),
                                                         c2: UIColor.init(netHex: 0xBA68C8),
                                                         c3: UIColor.init(netHex: 0x9C27B0),
                                                         c4: UIColor.init(netHex: 0x7B1FA2),
                                                         c5: UIColor.init(netHex: 0x4A148C))
            default:
                return TypeColor().newTypeColorFromSclae(c1: UIColor.init(netHex: 0xF5F5F5),
                                                         c2: UIColor.init(netHex: 0xE0E0E0),
                                                         c3: UIColor.init(netHex: 0x9E9E9E),
                                                         c4: UIColor.init(netHex: 0x616161),
                                                         c5: UIColor.init(netHex: 0x212121))
            }
        }
    }
    
    
}
