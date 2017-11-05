//
//  FeederController.swift
//  BNForm
//
//  Created by Darin Williams on 10/27/17.
//  Copyright © 2017 dwilliams. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import AlamofireRSSParser

class FeederController: UIViewController,UITableViewDelegate, UITableViewDataSource{

   
    @IBOutlet weak var rssFeederTable: UITableView!
    
    var articleSvc = ArticleSvcCache.getInstance()
    
       
    override func viewDidLoad() {
        super.viewDidLoad()

        //call alamofire rss reader
        fetchRSSArticles()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        
        var count:Int?
        
        if tableView == self.rssFeederTable{
            count = self.articleSvc.retrieveAll().count
            print("RSSFeed Svc Cache Count", count)
        }
        
        return count!;
    }

   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        // Configure the cell...
        let cellData = self.rssFeederTable.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleCell

        
    
        cellData.title!.text = self.articleSvc.getArticle(index: indexPath.row).title
        
        cellData.desc!.text = self.articleSvc.getArticle(index: indexPath.row).desc
        
        

        return cellData
    }
    
    
    func fetchRSSArticles(){
        
        let url = "https://www.cpsc.gov/Newsroom/CPSC-RSS-Feed/Recalls-RSS"
        

        Alamofire.request(url).responseRSS() { (response) -> Void in
            if let feed: RSSFeed = response.result.value {
                //do something with your new RSSFeed object!
                
                do{
                    
                    for item in feed.items {
                        let rssArticle = Article()
                        
                        //Get title
                        print(item.title)
                        let title = item.title as! String
                        rssArticle.title = title
                        
                        //Get description
                        print(item.itemDescription)
                        let desc = item.itemDescription as! String
                        rssArticle.desc = desc
                        
                        
                        //Get Link
                        print(item.link)
                        let urlLink = item.link as! String
                        rssArticle.urlLink = urlLink as!String
                        
                        DispatchQueue.main.async {
                            self.articleSvc.create(rssFeeder: rssArticle)
                            self.rssFeederTable?.reloadData()
                        }
                    }
                    
                } catch let error{
                    
                    print(error)
                }
                
                
            }
        }
        
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
