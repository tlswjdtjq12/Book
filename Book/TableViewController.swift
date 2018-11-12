//
//  TableViewController.swift
//  Book
//
//  Created by D7703_19 on 2018. 11. 12..
//  Copyright © 2018년 hsw. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var items:[Any]!
    override func viewDidLoad() {
        super.viewDidLoad()
        search(query: "가을", page: 1)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func search(query:String, page:Int) {
        let str = "https://dapi.kakao.com/v3/search/book?query=\(query)&page=\(page)" as NSString
        if let strURL = str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            if let url = URL(string: strURL){
                var request = URLRequest(url: url)
                request.addValue("KakaoAK 58b3119121102e3fa63fa60652174e05", forHTTPHeaderField: "Authorization")
                let session = URLSession.shared
                let task = session.dataTask(with: request, completionHandler: handler)
                task.resume()
            }
        }
        
    }
    
    func handler(data:Data?, response:URLResponse?, error:Error?) -> Void {
        if error != nil { return }
        
        if let dat = data {
            do {
                if let dic = try JSONSerialization.jsonObject(with: dat, options: [])as? [String:Any]{
                    if let books = dic["documents"] as? [Any]{
                        print(books)
                        items = books
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                    }
                }
            } catch{
                print("parsing error")
            }
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if let items =  items {
            return items.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let books = items {
            if let book = items[indexPath.row] as? [String:Any]{
            cell.textLabel?.text = book["title"] as? String
            }
        }
        return cell
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
