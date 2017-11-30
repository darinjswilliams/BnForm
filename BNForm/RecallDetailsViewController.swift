//
//  RecallDetailsViewController.swift
//  BNForm
//
//  Created by Darin Williams on 11/12/17.
//  Copyright © 2017 dwilliams. All rights reserved.
//

import UIKit

class RecallDetailsViewController: UIViewController {
    

    
    @IBOutlet weak var recallNumLabel: UILabel!
    
    @IBOutlet weak var recallDateLabel: UILabel!
    
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var productUpcLabel: UILabel!
    
    //Perform cleanup before allocation
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        recallNumLabel.text = ""
        recallDateLabel.text = ""
        descLabel.text = ""
        productUpcLabel.text = ""
        
        NotificationCenter.default.addObserver(self, selector: "setLabels:", name: NSNotification.Name(rawValue: "RecallNotification"), object: nil)    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setLabels(notication: NSNotification){
        
        //Initialize with data from DataService
        let recallInfo = RecallDTO(recallNumber: DataService.dataService.RECALL_NUMBER, products: DataService.dataService.PRODUCTS, productUpc: DataService.dataService.PRODUCT_UPC, recallDate: DataService.dataService.RECALL_DATE)
        
        recallNumLabel.text = "\(recallInfo.recallNumber)"
        recallDateLabel.text = "\(recallInfo.recallDate)"
        descLabel.text = "\(recallInfo.products)"
        productUpcLabel.text = "\(recallInfo.productUpc)"
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
