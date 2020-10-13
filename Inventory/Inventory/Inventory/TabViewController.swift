//
//  TabViewController.swift
//  
//
//  Created by Atharv Sathe on 18/08/19.
//

import UIKit

class TabViewController: UITabBarController {
    var sheetAPIs: sheetAPI?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let coirScene = self.selectedViewController as? CoirTableViewController {
            coirScene.sheetAPIs = sheetAPIs
        }
    }
    
}
