//
//  RecallPopUp.swift
//  BNForm
//
//  Created by Darin Williams on 10/9/17.
//  Copyright © 2017 dwilliams. All rights reserved.
//

import UIKit

class RecallPopUp: UIViewController {
    
    
 @IBOutlet weak var recallPopUpView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //round the corners
        recallPopUpView.layer.cornerRadius = 10
        
        //mask the bounds so popup will have same view as parent 
        
        recallPopUpView.layer.masksToBounds = true
    }
 

  
    @IBAction func closePopup(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }

}
