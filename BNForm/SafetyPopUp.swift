//
//  SafetyPopUp.swift
//  BNForm
//
//  Created by Darin Williams on 10/9/17.
//  Copyright © 2017 dwilliams. All rights reserved.
//

import UIKit

class SafetyPopUp: UIViewController {

    
    //Manage Popup Windows
    
    @IBOutlet weak var imgPhoto: UIImageView!
    
    @IBOutlet weak var recallNmber: UITextField!
    
    
    @IBOutlet weak var recallNotes: UITextView!
    
    
    @IBOutlet weak var safetyPopupView: UIView!
    
    var recallProducts = RecallProducts()
    
    
    
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

    
    override func viewWillAppear(_ animated: Bool) {
        print("view will appear", self.recallProducts.getDescription())
        
        self.recallNmber?.text = String(self.recallProducts.getId())
        self.recallNotes?.text = self.recallProducts.getNotes()
        
        self.imgPhoto?.image = recallProducts.getImage()
        
        print(self.recallProducts.getImage())
    }
    
    

}
