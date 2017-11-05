//
//  ArticleSvcCache.swift
//  BNForm
//
//  Created by Darin Williams on 10/29/17.
//  Copyright © 2017 dwilliams. All rights reserved.
//

import Foundation

class ArticleSvcCache: ArticleSvc {
   

var article = [Article]()


private init(){
    
}

private static var instance = ArticleSvcCache()

static func getInstance()->ArticleSvc{
    
    return instance
}

func retrieveAll() -> [Article] {
    return article
}

func getCount() -> Int {
    return article.count
}

    
func create(rssFeeder: Article){
   article.append(rssFeeder)
}



func getArticle(index: Int) -> Article {
    return article[index]
}

}
