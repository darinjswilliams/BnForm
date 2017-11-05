//
//  RssSvc.swift
//  BNForm
//
//  Created by Darin Williams on 10/29/17.
//  Copyright © 2017 dwilliams. All rights reserved.
//

import Foundation

protocol ArticleSvc {
    
    func retrieveAll()->[Article]
    func getCount()->Int
    func create(rssFeeder: Article)
    func getArticle(index: Int)->Article
}
