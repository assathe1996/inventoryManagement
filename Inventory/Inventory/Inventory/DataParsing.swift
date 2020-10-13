//
//  DataParsing.swift
//  Inventory
//
//  Created by Atharv Sathe on 19/08/19.
//  Copyright © 2019 Atharv Sathe. All rights reserved.
//

import Foundation

class DataParsing {
    var sheetAPIs: sheetAPI?
    var sheetId: String
    var material: Material
    
    private var rowsData: [Int: [String]] = [:]
    private var headingWidth: Int = 5
    public var finalData: [RawData] = []
    
    init(for material: Material, with sheetAPIs: sheetAPI?) {
        self.material = material
        self.sheetAPIs = sheetAPIs
        
        if material == .coir || material == .foam{
            sheetId = "1N9j2c0ETbLm3a42dJVus4WUBObjRwY3iXlPB9PMTE4c"
        } else if material == .cloth {
            sheetId = ""
        } else {
            sheetId = ""
        }
    }
    
    
   /* public func getData() {
        getRow(withIndex: 1)
        getRow(withIndex: 1000)
    }*/
    
   /* private func getRow(withIndex rowNumber: Int) {
        let rowCells = String(format: "A%d:AZ%d", rowNumber, rowNumber)
        self.sheetAPIs?.getData(from: sheetId, at: rowCells, onCompleted: { (data) in
            if let recievedData = data {
                let rowString = self.convertToStringArray(for: recievedData)
                let formattedRowString = self.deleteExcess(from: rowString)
                self.rowsData[rowNumber] = formattedRowString
                
                if self.rowsData[1] != nil && self.rowsData[1000] != nil {
                    for count in 0..<6 {
                        let element = self.rowsData[1]![count * self.headingWidth]
                        let quantity = Int(self.rowsData[1000]![4 + (count * self.headingWidth)])
                        self.finalData.append(RawData(element: element, quantity: quantity!))
                    }
                }
            }
        })
    }*/

    private func convertToStringArray(for recievedData: [[Any]]) -> [String] {
        var finalStringArray: [String] = []
        for count in 0..<recievedData[0].count {
            if let element = recievedData[0][count] as? String {
                finalStringArray.append(element)
            }
        }
        return finalStringArray
    }
    
    private func deleteExcess(from rowArray: [String]) -> [String] {
        var finalRowArray = rowArray
        for _ in 0..<finalRowArray.count {
            if let lastElement = finalRowArray.last, lastElement == "" {
                finalRowArray.removeLast()
            } else {
                break
            }
        }
        return finalRowArray
    }
}

struct RawData {
        var element: String
        var quantity: Int
    }

enum Material: Int {
    case coir
    case foam
    case cloth
    static let allCases: [Material] = [.coir, .foam, .cloth]
}
