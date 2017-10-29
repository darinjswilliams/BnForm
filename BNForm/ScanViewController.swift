//
//  ScanViewController.swift
//  BNForm
//
//  Created by Darin Williams on 10/8/17.
//  Copyright © 2017 dwilliams. All rights reserved.
//

import UIKit

class ScanViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func homeBtnPressed(_ sender: Any) {
        print("HomeButton Pressed")
        
        performSegue(withIdentifier: "scanToHome", sender: self)
    }
    
    @IBAction func scanShareBttn(_ sender: Any) {
        let activityVC = UIActivityViewController(activityItems: ["www.google.com"], applicationActivities: nil)
        
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
        
    }
    @IBAction func productSearch(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "goSearchProduct", sender: self)
    }
    
    
    @IBAction func createReport(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "goCreateReport", sender: self)
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
