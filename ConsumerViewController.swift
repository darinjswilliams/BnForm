//
//  ConsumerViewController.swift
//  BNForm
//
//  Created by Darin Williams on 10/16/17.
//  Copyright © 2017 dwilliams. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ConsumerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var recallTableView: UITableView!
    

    @IBOutlet weak var safetyTableView: UITableView!
    
    
    var recallProducts = [RecallProducts]()
    
    var recallSvcCache = RecallSvcCache.getInstance()
    
    var recallProd = RecallProducts()
    
    
    var safeProducts = [SafeProducts]()
    
    var safetySvcCache = ProductSvcCache.getInstance()
    
    var safeProd = SafeProducts()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //call alamofire
        alamofire()

        // Do any additional setup after loading the view.
//        let recallItem = RecallProducts()
//        recallItem.image = UIImage(named: "handgunsecurity.jpg")!
//        recallItem.description = "Hand Gun Security"
//        recallItem.id = 456789
//        self.recallSvcCache.create(recallProduct: recallItem)
//        
//        let recallItem2 = RecallProducts()
//        recallItem2.image = UIImage(named: "weedwacker.jpg")!
//        recallItem2.description = "Weed Wacker"
//        recallItem2.id = 333456
//        self.recallSvcCache.create(recallProduct: recallItem2)
//   
//        self.recallTableView.reloadData()
//        
//        
//        let safetyItem = SafeProducts()
//        safetyItem.image = UIImage(named: "weddingKnifes.jpg")!
//        safetyItem.description = "Wedding Knifes"
//        safetyItem.id = 82348
//        self.safetySvcCache.create(safeProduct: safetyItem)
//        
//        
//        let safetyItem2 = SafeProducts()
//        safetyItem2.image = UIImage(named: "WiggleBall")!
//        safetyItem2.description = "Wiggle Ball"
//        safetyItem2.id = 23456
//        self.safetySvcCache.create(safeProduct: safetyItem2)
//    
//        self.safetyTableView.reloadData()
//        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        var count:Int?
        
        if tableView == self.recallTableView{
            count = self.recallSvcCache.retrieveAll().count
            print("Recall Svc Cache Count", count)
        }
        
        if tableView == self.safetyTableView{
            count = self.safetySvcCache.retrieveAll().count
        }
        
        return count!;
               
    }
    
    

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        
       var cellData:UITableViewCell?
        
       
        
        if tableView == self.recallTableView{
            
            let cellData  = self.recallTableView.dequeueReusableCell(withIdentifier: "RecallCells", for: indexPath)
            
            
            //Get Text from DataSource
            cellData.textLabel!.text = self.recallSvcCache.getRecallProduct(index: indexPath.row).description
            
            //Get Image
            cellData.imageView!.image = self.recallSvcCache.getRecallProduct(index: indexPath.row).image
        
            
        }
        
        if tableView == self.safetyTableView{
            
            
            let cellData = self.safetyTableView.dequeueReusableCell(withIdentifier: "SafetyCells", for: indexPath)
            
            //Get text
            cellData.textLabel!.text = self.safetySvcCache.getSafeProduct(index: indexPath.row).description
            
            //Get image
            
            cellData.imageView!.image = self.safetySvcCache.getSafeProduct(index: indexPath.row).image
            
        }
        
        if cellData != nil{
            return cellData!
        }
    
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          print("Cell \(indexPath.row)")
        
          recallProd = recallSvcCache.getRecallProduct(index: indexPath.row)
          performSegue(withIdentifier: "ProductsRecall", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Entering Prepare for Seque")
        let destination = ( segue.destination as? SafetyPopUp)
        if segue.identifier == "ProductsRecall"{
            destination?.recallProducts = recallProd
            recallProducts = [RecallProducts()]
        }
        print("Existing Prepare for Seque")
        
    }
    
    
        func alamofire(){
            Alamofire.request("https://www.saferproducts.gov/RestWebServices/Recall?format=json&Images=Child&RecallDescription=metal&DateEnd=2016-01-01&ProductName=ball").responseJSON{ response in
    
    
                if let value = response.result.value{
    
    
                    var dictionary = [String]()
                    
                    if let value = response.result.value {
    
                        let dictionary = value as! NSArray
    
    
                        for dataInfo in dictionary as! [Dictionary<String, AnyObject>]{
    
                                //Initialize Recall Products
                                let recallProducts = RecallProducts()
    
    
                                //Get Images Arrary
                                let imgPhoto = dataInfo["Images"] as! NSArray
    
                                //Get Recall Number
                                let  recallNumber = dataInfo["RecallNumber"] as! String
                            
                                //Get Description
                                let description = dataInfo["Description"] as! String
                                recallProducts.notes = description
    
    
                                let aProduct = dataInfo["Products"] as! NSArray
    
                                //Populate Model RecallNumber
                                recallProducts.id = Int(recallNumber)!
    
    
                            for prodDesc in aProduct as! [Dictionary<String, AnyObject>]{
    
                                if let foundProdct = prodDesc["Name"] as? String{
    
                                    //popuate service
                                    recallProducts.description = foundProdct
    
                                }
    
    
                            } //end of product description
    
                                //Get Images
                            for aImgPhoto in imgPhoto as! [Dictionary<String, AnyObject>]{
    
                                if let fndImg = aImgPhoto["URL"] as? String {
    
                                      print(fndImg)
    
                                    //Get image from URL
                                    Alamofire.request(fndImg).responseImage(completionHandler: { (response) in
                                        print(response)
    
                                        // Call DispatchQueue here
                                        if let image = response.result.value{
                                           recallProducts.image = image
                                              DispatchQueue.main.async {
                                                
                                               self.recallSvcCache.create(recallProduct: recallProducts)
                                                self.recallTableView.reloadData()

                                                
                                            }
                                        }
    
                                    })
                                  } //Closure for image
    
                                }// Image for loop

    //                            print(recallProducts.toString())
                                //Add to array
    //                            self.recallItems.append(recallProducts)
    
                            //Call service
    
    
                          }
//                        DispatchQueue.main.async {
////                          self.recallSvcCache.create(recallProduct: recallProducts)
//                            self.recallTableView.reloadData()
//                        }
    
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
