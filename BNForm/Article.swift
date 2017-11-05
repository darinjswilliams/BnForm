//
//  Article.swift
//  BNForm
//
//  Created by Darin Williams on 10/29/17.
//  Copyright © 2017 dwilliams. All rights reserved.
//
import Foundation
import UIKit

class Article{
    
    var title:String
    var urlLink:String
    var desc:String
    var imageUrl:String
    
    
  init(){
        desc = ""
        urlLink = ""
        title  = ""
        imageUrl = ""
    }
    
    
    func getUrlLink()->String{
        return urlLink
    }
    
    func getDesc()->String{
        return desc
    }
    
    func getTitle()->String{
        return title
    }
    
    func getImageUrl()->String{
        return imageUrl
    }
    
    func toString()->String{
        return "\(urlLink) \(title)) \(desc)"
    }

}
