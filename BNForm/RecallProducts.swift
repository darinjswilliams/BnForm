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
    
    
    var id:Int
    var description:String
    var image:UIImage?
    var notes:String

    
    init(){
        description = ""
        id = 0
        notes = ""
        image = nil
    }
    
    
    func getImage()->UIImage{
        return image!
    }
    
    func getDescription()->String{
        return description
    }
    
    func getId()-> Int{
        return id
    }
    
    func getNotes()->String{
        return notes;
    }
    
    func toString()->String{
        return "\(image) \(id) \(description)"
    }
}
