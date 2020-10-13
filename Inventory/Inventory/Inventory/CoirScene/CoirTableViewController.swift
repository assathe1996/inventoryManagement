//
//  CoirTableViewController.swift
//  Inventory
//
//  Created by Atharv Sathe on 18/08/19.
//  Copyright © 2019 Atharv Sathe. All rights reserved.
//

import UIKit

class CoirTableViewController: UITableViewController {
    var data: [CoirData] = []
    var sheetAPIs: sheetAPI?
    private var sheetID:String = "1N9j2c0ETbLm3a42dJVus4WUBObjRwY3iXlPB9PMTE4c"
    private var headingWidth: Int = 5
    public var test = false
    
    // MARK: - Logical functions
    private func loadData() {
        sheetAPIs?.getCoirData(from: sheetID)
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            while self?.sheetAPIs?.coirDataRecievedFlag == false {}
            self?.sheetAPIs?.coirDataRecievedFlag = false
            DispatchQueue.main.async {
                if let recievedData = self?.sheetAPIs?.coirData {
                    self?.data.removeAll()
                    self?.data += recievedData
                }
                self?.tableView.reloadData()
            }
        }
    }

    @objc private func updateData() {
        loadData()
        refreshControl?.endRefreshing()
    }
    
    // MARK: - View Lifecycle functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(updateData), for: .valueChanged)
        self.refreshControl = refreshControl
    }
       

    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoirCell", for: indexPath)
        tableView.rowHeight = CGFloat(75)
        if let customCell = cell as? CoirTableViewCell {
            customCell.coirView.element = data[indexPath.row].element
            customCell.coirView.quantity = data[indexPath.row].quantity
            customCell.coirView.isCoir = data[indexPath.row].isCoir
        }
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "GoToCoirDetailView" {
                if let cell = sender as? CoirTableViewCell {
                    let indexPath = tableView.indexPath(for: cell)
                    if let detailDisplay = segue.destination as? CoirDetailTableViewController {
                        detailDisplay.cellIndex = indexPath!.row
                        detailDisplay.sheetAPIs = sheetAPIs
                        detailDisplay.sheetID = sheetID
                    }
                }
            }
        }
    }
   
    

    
    

    /*/*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
    
    */*/

}






