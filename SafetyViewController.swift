//
//  SafetyViewController.swift
//  BNForm
//
//  Created by Darin Williams on 10/14/17.
//  Copyright © 2017 dwilliams. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage


class SafetyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Connect to Database
    var recallProducts = [RecallProducts]()
//    let recallItems = ["weedwacker", "weddingKnifes","handgunsecurity"]
    
    var selectedRecallProduct = RecallProducts()
    
    var recallSvc: RecallSvc = RecallSvcCache.getInstance()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        alamofire()
        


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    return self.recallSvc.retrieveAll().count
    }
    
    
  
   public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
    
    let cellRecall = tableView.dequeueReusableCell(withIdentifier: "cellRecall", for: indexPath) as! RecallControllerTableViewCell
    
    cellRecall.recallImage.image = self.recallSvc.getRecallProduct(index: indexPath.row).image
    
    cellRecall.recallDesc?.text = self.recallSvc.getRecallProduct(index: indexPath.row).description
    
    return cellRecall
        
    }
    
    
    func alamofire(){
        Alamofire.request("https://www.saferproducts.gov/RestWebServices/Recall?format=json&Images=Child&RecallDescription=metal&DateEnd=2016-01-01&ProductName=ball").responseJSON{ response in
            
            
            if let value = response.result.value{
                
                
                var dictionary = [String]()
                var imgPic = [UIImage]()
                
                if let value = response.result.value {
                    
                    
                    
                    let dictionary = value as! NSArray
                    
                    
                    
                    for dataInfo in dictionary as! [Dictionary<String, AnyObject>]{
                        
                        //Initialize Recall Products
                        let recallProducts = RecallProducts()
                        
                        
                        //Get Images Arrary
                        let imgPhoto = dataInfo["Images"] as! NSArray
                        
                        //Get Recall Number
                        let  recallNumber = dataInfo["RecallNumber"] as! String
                        
                        //Populate Model RecallNumber
                        recallProducts.id = Int(recallNumber)!
                        print(recallNumber)

                        
                        let aProduct = dataInfo["Products"] as! NSArray
  
                        for prodDesc in aProduct as! [Dictionary<String, AnyObject>]{
                            
                            if let foundProdct = prodDesc["Name"] as? String{
                                
                                //popuate service
                                recallProducts.description = foundProdct
                                print(recallProducts.description)
                                
                            }
                            
                            
                        } //end of product description
                        
                        
                        //Get Images
                        for aImgPhoto in imgPhoto as! [Dictionary<String, AnyObject>]{
                            
                            if let fndImg = aImgPhoto["URL"] as? String {
                                
                                print(fndImg)
                                
                                //Get image from URL
                                Alamofire.request(fndImg).responseImage(completionHandler: { (response) in
                                    print(response)
                                    
                                
                                    if let image = response.result.value{
                                        recallProducts.image = image
//                                         recallProducts.image.append(image)
                                        //Call service
                                       
                                        self.recallSvc.create(recallProduct: recallProducts)
                                        
                                      

                                    }
                                    
                                })
                            } //Closure for image
                            
                        }// Image for loop

//                         self.recallProducts.append(recallProducts)
                        
                        
                    
                        
                    }
//                    DispatchQueue.main.async {
//                   
//                    }
                    
                }
                
                
            }
            
            
        } //end of responseJson
        
    }

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
