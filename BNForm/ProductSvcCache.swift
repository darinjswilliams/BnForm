//
//  ProductSvcCache.swift
//  BNForm
//
//  Created by Darin Williams on 10/6/17.
//  Copyright © 2017 dwilliams. All rights reserved.
//
// Implementation

import Foundation

class ProductSvcCache: ProductSvc{
    
    var safeProducts = [SafeProducts]()
    
    func create(safeProduct: SafeProducts) {
        safeProducts.append(safeProduct)
    }
    
    func update(safeProduct: SafeProducts) {
        //code
    }
    
    func delete(safeProduct: SafeProducts) {
        var index = 0
        
        for next in safeProducts{
            if next.description == safeProducts.description{
                NSLog("Removing" + safeProducts.description)
                
                safeProducts.remove(at: index)
                
            }
            
            index += 1
            
        }
    }
    
    func getCount() -> Int {
        return safeProducts.count
    }
    
    func getSafeProduct(index: Int) -> SafeProducts {
        return safeProducts[index]
    }
    
    func retrieveAll() -> [SafeProducts] {
        return safeProducts
    }
    
    
}
