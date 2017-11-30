//
//  BNFormTests.swift
//  BNFormTests
//
//  Created by Darin Williams on 10/4/17.
//  Copyright © 2017 dwilliams. All rights reserved.
//

import XCTest
import FirebaseAuth
import FirebaseCore
import Alamofire
import SwiftyJSON


@testable import BNForm


class BNFormTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testNSurl(){
        NSLog("Entering testNSRurl")
        
        let requestURL:NSURL = NSURL(string: "https://www.saferproducts.gov/RestWebServices/Recall?Title=Child&RecallDescription=metal&format=Json")!
        
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        
        //Create URL Session
        let session = URLSession.shared
       
        
        
        //Create Background task
        let task = session.dataTask(with: urlRequest as URLRequest){
            (data, response, error) -> Void in
            
            
            let httpResponse = response as! HTTPURLResponse
            XCTAssertNil(httpResponse, "httpResponse is nil")
            
            let statusCode = httpResponse.statusCode
            NSLog("statusCode \(statusCode)")
            
            XCTAssertEqual(statusCode, 0, "statusCode=\(statusCode); expected 100")
            
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
        
    
        NSLog("Here is task", task)
        
    }//testNSurl
    
    func testSearch(){
        let requestURL:NSURL = NSURL(string: "https://www.saferproducts.gov/RestWebServices/Recall?Title=Child&RecallDescription=metal&format=Json")!
        
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        
        //Create URL Session
        let session = URLSession.shared
        XCTAssertNotNil(session)
        
        
        //Create Background task
        let task = session.dataTask(with: urlRequest as URLRequest){
            (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            
            let statusCode = httpResponse.statusCode
            print(statusCode)
            XCTAssert(statusCode == 100, "statusCode= \(statusCode); expected 500")
        }
        
        
    }
    
    func testRecallSearch(){
        let codeNumber = "ball"
        
        let searchRecallURL = "\(RECALL_SEARCH)&Description=\(codeNumber)&format=Json"
        
        
        
        Alamofire.request(searchRecallURL).responseJSON{ response in
            
            
         
            
             if((response.result.value) != nil) {
               var json = JSON(response.result.value!)
               
           
            
                let recall_number = "\(json["results"][0]["title"])"
                let recall_date = "\(json["results"][0]["year"])"
                let product_upc = "\(json["results"][0]["year"])"
                let products    = "\(json["results"][0]["year"])"
                
          
                
                print(recall_number)
                print(recall_date)
                print(product_upc)
                print(products)
                
            }
                // Post a notification to let RecallDetailsViewController know we have some data.
                
                //                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RecallNotification"), object: nil)

        }
    }
    
    func testAlamoFire(){
        
     
        let codeNumber = "ball"
        
        let searchRequestURL = URL(string: "\(RECALL_SEARCH)&Description=\(codeNumber)&format=Json")
        
//        let expectations = expectation(description: "The Response result match the expected results")
       
            
            let request = Alamofire.request(searchRequestURL!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
           
        
            request.responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let result): break
                    //do the checking with expected result
                    //AssertEqual or whatever you need to do with the data
                    //finally fullfill the expectation
                   
                case .failure(let error):
                    //this is failed case
                    XCTFail("Server response failed : \(error.localizedDescription)")
                 
                }
            })
            
            //wait for some time for the expectation (you can wait here more than 30 sec, depending on the time for the response)
            waitForExpectations(timeout: 30, handler: { (error) in
                if let error = error {
                    print("Failed : \(error.localizedDescription)")
                }
                
            })
        
    }
    
}
