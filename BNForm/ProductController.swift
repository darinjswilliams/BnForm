//
//  ProductViewController.swift
//  BNForm
//
//  Created by Darin Williams on 10/5/17.
//  Copyright © 2017 dwilliams. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class RecallPopulationCells: UITableViewCell{
    
    
    @IBOutlet var recallDesc: UILabel!
    @IBOutlet var imgRecall: UIImageView!
    

}

class SafetyPopulationCells: UITableViewCell{
    
    
    @IBOutlet var safteyDesc: UILabel!
    @IBOutlet var imgSafety: UIImageView!
    
   
}


class ProductController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    
    //Connect to Database
    var recallItems: [RecallProducts] = []
    
    var safetyItems: [SafeProducts] = []
    

    @IBOutlet weak var recallTableView: UITableView!
    
    @IBOutlet weak var safetyTableView: UITableView!
    
    @IBAction func scanProductButton(_ sender: UIButton) {
    }
    
    var safeProductSvcCache = ProductSvcCache()
    
    var recallSvc: RecallSvc = RecallSvcCache.getInstance()
    
    
    override func viewDidAppear(_ animated: Bool) {
        print("ViewDidAppear", safetyItems.description)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //code
        var count:Int?
        
        if tableView == self.recallTableView{
            count = recallSvc.retrieveAll().count
            print("Recall Svc Cache Count", count)
        }
        
        if tableView == self.safetyTableView{
            count = safeProductSvcCache.getCount()
        }
        
        return count!;
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
   
        
        if tableView == self.recallTableView{
            
            let cellData:RecallPopulationCells = self.recallTableView.dequeueReusableCell(withIdentifier: "recallCells", for: indexPath) as! RecallPopulationCells
            
            
            //Get Text from DataSource
            cellData.recallDesc.text = recallSvc.getRecallProduct(index: indexPath.row).description
            
            //Get Image
            cellData.imgRecall.image = recallSvc.getRecallProduct(index: indexPath.row).image

            

            return cellData
            
        }
        
               if tableView == self.safetyTableView{
            
            
            let cellData:SafetyPopulationCells = self.safetyTableView.dequeueReusableCell(withIdentifier: "safetyCells", for: indexPath) as! SafetyPopulationCells
            
            //Get text 
            cellData.safteyDesc.text = safeProductSvcCache.getSafeProduct(index: indexPath.row).description
            
            //Get image
            
            cellData.imgSafety.image = safeProductSvcCache.getSafeProduct(index: indexPath.row).image
            
            return cellData
            
        }
        
        
        return UITableViewCell()
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        NSLog("Cell #\(indexPath.row)!")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Display list of programs with scene is loaded
        alamofire()
    
    
        //Register table View
        self.recallTableView.register(UITableViewCell.self, forCellReuseIdentifier: "RecallCells")
        
        
        self.safetyTableView.register(UITableViewCell.self, forCellReuseIdentifier: "SafetyCells")
        
        
     
       // saveRecallProducts()
        saveSafeProducts()

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
                                        self.recallSvc.create(recallProduct: recallProducts)
//                                        recallProducts.image.append(image)
                                    }
                                    
                                })
                              } //Closure for image
                            
                            }// Image for loop
                        
                        
                        
                        
                       
//                            print(recallProducts.toString())
                            //Add to array
//                            self.recallItems.append(recallProducts)
                        
                        //Call service
                        
                       
                      }
                    DispatchQueue.main.async {
                        self.recallTableView.reloadData()
                    }

                }
                
             
            }
            
            
        } //end of responseJson
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func saveSafeProducts()
    {
        let safeProduct = SafeProducts()
        safeProduct.description = "Resistant Bands"
        safeProduct.image = #imageLiteral(resourceName: "resistBnds")
        
        safeProductSvcCache.create(safeProduct: safeProduct)
        
        
        
    }
    
    func saveRecallProducts(){
        
//        let recallProduct = RecallProducts()
//        recallProduct.description = "Wiggle Ball"
//        recallProduct.image = [#imageLiteral(resourceName: "WiggleBall")]
//        recallSvc.create(recallProduct: recallProduct)
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
