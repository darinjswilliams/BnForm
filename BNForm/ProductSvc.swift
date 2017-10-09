//
//  ProductSvc.swift
//  BNForm
//
//  Created by Darin Williams on 10/6/17.
//  Copyright © 2017 dwilliams. All rights reserved.
//
//  Interface

import Foundation

protocol ProductSvc {
    
    func create(safeProduct: SafeProducts)
    func retrieveAll()->[SafeProducts]
    func delete(safeProduct: SafeProducts)
    func update(safeProduct: SafeProducts)
    
    func getCount()->Int
    func getSafeProduct(index: Int)->SafeProducts
}
