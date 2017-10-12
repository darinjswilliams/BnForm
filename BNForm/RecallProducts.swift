//
//  RecallProducts.swift
//  BNForm
//
//  Created by Darin Williams on 10/6/17.
//  Copyright © 2017 dwilliams. All rights reserved.
//

import Foundation
import UIKit

class RecallProducts{
    
    
    //["In123478","IN345677","IN678900"]
    var id:Int
    var description:String
    var image:[UIImage] = []
    
    init(){
        description = ""
        image = []
        id = 0
    }
    
    
    func getImage()->[UIImage]{
        return image
    }
    
    func getDescription()->String{
        return description
    }
    
    func getId()-> Int{
        return id
    }
    
    func toString()->String{
        return "\(image) \(id) \(description)"
    }
}
