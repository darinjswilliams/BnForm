//
//  BNFormTests.swift
//  BNFormTests
//
//  Created by Darin Williams on 10/4/17.
//  Copyright © 2017 dwilliams. All rights reserved.
//

import XCTest
@testable import BNForm

class BNFormTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testNSurl(){
        
        
        let requestURL:NSURL = NSURL(string: "https://www.saferproducts.gov/RestWebServices/Recall?Title=Child&RecallDescription=metal&format=Json")!
        
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        
        //Create URL Session
        let session = URLSession.shared
        
        
        //Create Background task
        let task = session.dataTask(with: urlRequest as URLRequest){
            (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            
            let statusCode = httpResponse.statusCode
            if(statusCode == 200){
                
                print("Response Recieved")
                
                do{
                    if let data = data,
                    //parse the json response as a dictionary
                     let json = try JSONSerialization.jsonObject(with: data, options:.allowFragments ) as? [String: Any],
 
                      let recallItems = json["Recall"] as? [[String: Any]]{
                        for rItem in recallItems{
                            if let rnum = rItem["RecallNumber"] as? String{
                                
                                print(rnum)
                            }
                            
                        }

                    
                    }
                    
                    
                } catch{
                    
                    print("Error with json \(error)")
                    
                }// do catch
                
            } //StatusCode
            
                       

            
        } //Backgound task
        
    }//testNSurl
    
}
