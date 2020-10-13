//
//  CoirDetailTableViewCell.swift
//  Inventory
//
//  Created by Atharv Sathe on 30/08/19.
//  Copyright © 2019 Atharv Sathe. All rights reserved.
//

import UIKit

class CoirDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var coirDetailView: CoirDetailView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.coirDetailView.date = ""
        self.coirDetailView.quantity = 0
        self.coirDetailView.balance = 0
    }
}
