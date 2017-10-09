//
//  RecallSvc.swift
//  BNForm
//
//  Created by Darin Williams on 10/6/17.
//  Copyright © 2017 dwilliams. All rights reserved.
//

import Foundation

protocol RecallSvc {
    
    func retrieveAll()->[RecallProducts]
    func create(recallProduct: RecallProducts)
    func getCount()->Int
    func getRecallProduct(index: Int)->RecallProducts
}
