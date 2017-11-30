//
//  Results.swift
//  BNForm
//
//  Created by Darin Williams on 11/24/17.
//  Copyright © 2017 dwilliams. All rights reserved.
//

import Foundation

//Generic enum that can recieve results of success or error

enum Results<T>{
    case success(T)
    case error
}
