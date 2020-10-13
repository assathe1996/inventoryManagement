//
//  CoirDetailTableViewController.swift
//  Inventory
//
//  Created by Atharv Sathe on 30/08/19.
//  Copyright © 2019 Atharv Sathe. All rights reserved.
//

import UIKit

class CoirDetailTableViewController: UITableViewController {
    let cellHeight: CGFloat = 40
    var cellIndex: Int?
    var detailData: [CoirDetailData] = []
    var sheetAPIs: sheetAPI?
    var sheetID: String?
    
    private func loadData() {
        sheetAPIs?.getDetailCoirData(from: sheetID!, forSize: cellIndex!)
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            while self?.sheetAPIs?.coirDetailDataRecievedFlag == false {}
            self?.sheetAPIs?.coirDetailDataRecievedFlag = false
            DispatchQueue.main.async {
                if let recievedData = self?.sheetAPIs?.coirDetailData {
                    self?.detailData.removeAll()
                    self?.detailData += recievedData
                    //print(self?.detailData)
                }
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoirDetailCell", for: indexPath)
        tableView.rowHeight = CGFloat(cellHeight)
        if let customCell = cell as? CoirDetailTableViewCell {
            //customCell.coirDetailView.date = detailData[indexPath.row].date!
            customCell.coirDetailView.date = (detailData[indexPath.row].unixTime?.getDateStringFromUTC())!
            customCell.coirDetailView.quantity = detailData[indexPath.row].quantity!
            customCell.coirDetailView.balance = 34
            print(indexPath.row, detailData[indexPath.row].unixTime?.getDateStringFromUTC())
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
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension Double {
    func getDateStringFromUTC() -> String {
        let date = Date(timeIntervalSince1970: self)

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateStyle = .medium

        return dateFormatter.string(from: date)
    }
}
