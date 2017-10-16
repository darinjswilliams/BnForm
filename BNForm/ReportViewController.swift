//
//  ReportViewController.swift
//  BNForm
//
//  Created by Darin Williams on 10/8/17.
//  Copyright © 2017 dwilliams. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    
    
    @IBOutlet weak var emailAddress: UITextField!
    
    
    @IBOutlet weak var connectNumbe: UITextField!
    
    @IBOutlet weak var rptImage: UIImageView!
    
    @IBOutlet weak var notes: UITextView!
    
    
    
    @IBAction func performRescan(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
    }
   

}
