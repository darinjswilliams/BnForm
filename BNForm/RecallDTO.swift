//
//  RecallDTO.swift
//  BNForm
//
//  Created by Darin Williams on 11/12/17.
//  Copyright © 2017 dwilliams. All rights reserved.
//

import Foundation

class RecallDTO {
 
    private (set) var recallNumber: String!
    private (set) var products: String!
    private (set) var productUpc: String!
    private (set) var recallDate: String!
    
    init(recallNumber: String, products: String, productUpc: String, recallDate: String){
        
        // Add extra text on Recall Item
        self.recallNumber = "Recall Number \(recallNumber)"
        self.recallDate = "Recall Date \(recallDate)"
        self.products = "Description \(products)"
        self.productUpc = "UPC \(productUpc)"
    }
    
    
}
