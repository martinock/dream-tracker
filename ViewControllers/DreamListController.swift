//
//  DreamListController.swift
//  DreamTracker
//
//  Created by nakama on 05/12/18.
//  Copyright © 2018 Tokopedia. All rights reserved.
//
import UIKit
import Alamofire

class DreamListController: UITableViewController {
    
    private var dreams = [Dream]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefault = UserDefaults.standard
        fetchDataFromAPI(token: userDefault.string(forKey: "token"))
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    private func fetchDataFromAPI(token: String?) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token ?? "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImZlckBmZXIuY29tIiwiaWQiOiIxIiwibmFtZSI6IkZlcmljbyJ9.XvvHvQyP8YuukKtyXsohpe1-H1BY-pWb94kbtnIL5PQ")"
        ],
        jsonDecoder = JSONDecoder()
        Alamofire.request("http://93.188.167.250:8080/me/dreams", headers: headers)
            .responseJSON{response in
                switch response.result {
                case .success(_):
                    if let data = response.data {
                        do {
                            let mappedResponse = try jsonDecoder.decode(DreamResponse.self, from: data)
                            
                            if mappedResponse.success {
                                self.dreams = mappedResponse.data ?? []
                                self.tableView.reloadData()
                            } else {
                                //Show alert when error
                                let alert = UIAlertController(title: "Get Dream Error", message: mappedResponse.error ?? "Please try again later", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                                    _ in
                                }))
                                
                                self.present(alert, animated: true, completion: nil)
                            }
                        } catch let error {
                            print(error)
                        }
                    }
                case .failure(let error):
                    //Show alert when error
                    var messageError = "Failure"
                    if error._code == NSURLErrorNotConnectedToInternet {
                        messageError = "No internet connection"
                    }
                    let alert = UIAlertController(title: "Failure", message: messageError, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        _ in
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                    break;
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
        return dreams.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dreamCell", for: indexPath) as? DreamViewCell else {
            fatalError("Expected only DreamViewCell")
        }
        // Configure the cell...
        cell.bindWith(dream: dreams[indexPath.row])
        
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
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
