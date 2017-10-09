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
    var description:String
    var image:UIImage?
    
    init(){
        description = ""
        image = nil
    }
    
    
    func getImage()->UIImage{
        return image!
    }
    
    func getDescription()->String{
        return description
    }
}
