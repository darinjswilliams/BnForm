//
//  SafeProducts.swift
//  BNForm
//
//  Created by Darin Williams on 10/6/17.
//  Copyright © 2017 dwilliams. All rights reserved.
//

import Foundation
import UIKit

class SafeProducts{
    var description:String
    var image:UIImage?
    
    //["Rpt334568","Rpt878930","Rpt764893"]
    
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
