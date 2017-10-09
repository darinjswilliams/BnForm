//
//  ProductViewController.swift
//  BNForm
//
//  Created by Darin Williams on 10/5/17.
//  Copyright © 2017 dwilliams. All rights reserved.
//

import UIKit

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
    
    var recallSvcCache = RecallSvcCache()
    
    override func viewDidAppear(_ animated: Bool) {
        print("ViewDidAppear", safetyItems.description)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //code
        var count:Int?
        
        if tableView == self.recallTableView{
            count = recallSvcCache.getCount()
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
            cellData.recallDesc.text = recallSvcCache.getRecallProduct(index: indexPath.row).description
            
            //Get Image
            cellData.imgRecall.image = recallSvcCache.getRecallProduct(index: indexPath.row).image
            
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
    
        //Register table View
        self.recallTableView.register(UITableViewCell.self, forCellReuseIdentifier: "RecallCells")
        
        
        self.safetyTableView.register(UITableViewCell.self, forCellReuseIdentifier: "SafetyCells")
        
     
        saveRecallProducts()
        saveSafeProducts()

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
        
        let recallProduct = RecallProducts()
        recallProduct.description = "Wiggle Ball"
        recallProduct.image = #imageLiteral(resourceName: "WiggleBall")
        recallSvcCache.create(recallProduct: recallProduct)
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
