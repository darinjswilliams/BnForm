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
import AlamofireRSSParser

class ConsumerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    
    @IBOutlet weak var recallTableView: UITableView!
    


    @IBOutlet weak var safetyTableView: UITableView!
    
    
    var recallProducts = [RecallProducts]()
    
    var filterData = [RecallProducts]()
    
    var recallSvcCache = RecallSvcCache.getInstance()
    
    var recallProd = RecallProducts()
    
 
    @IBOutlet weak var searchBar: UISearchBar!
    
    var isSearching = false
    
    var safeProducts = [SafeProducts]()
    
    var safetySvcCache = ProductSvcCache.getInstance()
    
    var safeProd = SafeProducts()
    
    @IBAction func verifyProductScan(_ sender: Any) {
        
        performSegue(withIdentifier: "goToScan", sender: self)
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //call alamofire
        alamofire()
        
        //Setup the Search Controller
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done
  
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        var count:Int?
        
        //return count on filter data if searching
        if isSearching{
            return filterData.count
            
        }
        
        if tableView == self.recallTableView{
            count = self.recallSvcCache.retrieveAll().count
            print("Recall Svc Cache Count", count)
        }
        
        
        
        
        return count!;
        
    }
    
  
    @IBAction func unwindSegueToVC(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("unwindSeque")
    }
    
    

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        
       var cellData:UITableViewCell?
        
        let foundTxt:String!
        
        
        if tableView == self.recallTableView{
            
            let cellData  = self.recallTableView.dequeueReusableCell(withIdentifier: "RecallCells", for: indexPath)
            
            if isSearching{
                
                cellData.textLabel!.text = filterData[indexPath.row].description
                
                cellData.imageView!.image = filterData[indexPath.row].image
            
            
            } else {
            
            
            //Get Text from DataSource
            cellData.textLabel!.text = self.recallSvcCache.getRecallProduct(index: indexPath.row).description
            
            //Get Image
            cellData.imageView!.image = self.recallSvcCache.getRecallProduct(index: indexPath.row).image
            }
            
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            
            isSearching = false
            
            view.endEditing(true)
            
            self.recallTableView.reloadData()
            
        } else {
            
            isSearching = true
            
//            filterData = data.
            
             self.recallTableView.reloadData()
        }
            
            
    }
    
    
        func alamofire(){
            Alamofire.request("https://www.saferproducts.gov/RestWebServices/Recall?format=json&Images=adult&RecallDateStart=2017-01-01&RecallEndDate=2017-01-10&ProductName=tv").responseJSON{ response in
    
    
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
                                                
                                            self.filterData.append(recallProducts)
                                                
                                            }
                                        }
    
                                    })
                                  } //Closure for image
    
                                }// Image for loop
    
                          }

    
                    }
                    
                 
                }
                
                
            } //end of responseJson
            
        }

  }


