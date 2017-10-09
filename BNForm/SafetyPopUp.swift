//
//  SafetyPopUp.swift
//  BNForm
//
//  Created by Darin Williams on 10/9/17.
//  Copyright © 2017 dwilliams. All rights reserved.
//

import UIKit

class SafetyPopUp: UIViewController {

    
    
    @IBOutlet weak var safetyPopupView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //round corners
        safetyPopupView.layer.cornerRadius = 20
        
        //mask it so all corners can be round
        safetyPopupView.layer.masksToBounds = true
    }

  
    @IBAction func closePopUp(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }

    
    

}
