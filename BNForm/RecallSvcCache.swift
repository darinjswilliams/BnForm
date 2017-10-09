//
//  RecallSvcCache.swift
//  BNForm
//
//  Created by Darin Williams on 10/6/17.
//  Copyright © 2017 dwilliams. All rights reserved.
//

import Foundation

class RecallSvcCache: RecallSvc{
   
    var recallProducts = [RecallProducts]()
    
    func retrieveAll() -> [RecallProducts] {
        return recallProducts
    }
    
    func getCount() -> Int {
        return recallProducts.count
    }
    
    func create(recallProduct: RecallProducts){
        recallProducts.append(recallProduct)
    }
    
    
    func getRecallProduct(index: Int) -> RecallProducts {
        return recallProducts[index]
    }
}
