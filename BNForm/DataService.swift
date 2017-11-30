//
//  DataService.swift
//  
//
//  Created by Darin Williams on 11/8/17.
//
//

import Foundation
import Alamofire
import SwiftyJSON
 

class DataService {
    
    static let dataService = DataService()
    
    //Make setter private
    private(set) var PRODUCT_UPC = ""
    private(set) var RECALL_NUMBER = ""
    private(set) var RECALL_DATE = ""
    private(set) var PRODUCTS = ""
    
    static func searchAPI(codeNumber: String) {
        
        // The URL we will use to get data from recall database
        
        let searchRecallURL = "\(RECALL_SEARCH)&Description=\(codeNumber)&format=Json"
        
        Alamofire.request(searchRecallURL)
            .validate()
            .responseJSON { response in
                
                switch response.result{
                
                case .success:
                var json = JSON(response.result.value!)
                
                let recall_number = "\(json["results"][0]["title"])"
                let recall_date = "\(json["results"][0]["year"])"
                let product_upc = "\(json["results"][0]["year"])"
                let products    = "\(json["results"][0]["year"])"
                
                self.dataService.RECALL_NUMBER = recall_number
                self.dataService.RECALL_DATE = recall_date
                self.dataService.PRODUCTS = products
                self.dataService.PRODUCT_UPC = product_upc
                
                print(recall_number)
                print(recall_date)
                print(product_upc)
                print(products)
                    
                case .failure(let error):
                    print(error)
                // Post a notification to let RecallDetailsViewController know we have some data.
                
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RecallNotification"), object: nil)
                }
      }
    }
}
