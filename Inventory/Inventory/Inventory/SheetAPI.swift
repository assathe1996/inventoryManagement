//
//  SheetAPI.swift
//  
//
//  Created by Atharv Sathe on 18/08/19.
//

import Foundation
import GoogleAPIClientForREST

class sheetAPI: NSObject {
    public var coirDataRecievedFlag: Bool = false
    public var coirDetailDataRecievedFlag: Bool = false
    var coirHeadings: Int = 5
    public var coirData: [CoirData] = []
    public var coirDetailData: [CoirDetailData] = []
    private let service: GTLRSheetsService
    
    
    init(service: GTLRSheetsService) {
        self.service = service
    }
    
    public func getCoirData(from sheetId: String) {
        let ranges: [String] = ["Coir!A1:AZ1", "Coir!A1000:AZ1000", "Foam!A1:AZ1", "Foam!A1000:AZ1000"]
        let query = GTLRSheetsQuery_SpreadsheetsValuesBatchGet.query(withSpreadsheetId: sheetId)
        query.ranges = ranges
        service.executeQuery(query, delegate: self, didFinish: #selector(dataResult(ticket:data:error:)))
    }
    
    public func getDetailCoirData(from sheetId: String, forSize element: Int) {
        var material: String = "Coir!"
        var column = element
        if element > 5 {
            material = "Foam!"
            column = element - 6
        }
        let startingColumn: Int = ((column) * coirHeadings) + 1
        var ranges: [String] = []
        for count in 0..<4 {
            let columnAlphabet = convertToAlphabet(withNumber: startingColumn + count)
            ranges.append(material + columnAlphabet + "3:" + columnAlphabet + "100")
        }
        let query = GTLRSheetsQuery_SpreadsheetsGet.query(withSpreadsheetId: sheetId)
        query.ranges = ranges
        query.includeGridData = true
        service.executeQuery(query, delegate: self, didFinish: #selector(detailDataResult(ticket:data:error:)))
    }
 
    @objc func dataResult(ticket: GTLRServiceTicket, data : GTLRSheets_BatchGetValuesResponse, error : NSError?) {
        var elementData: [String] = []
        var quantityData: [String] = []
        var numberOfCoir: Int = -1
        
        if let recievedData = data.valueRanges {
            for index in 0..<recievedData.count {
                if let rowData = recievedData[index].values {
                    let stringArray = convertToStringArray(for: rowData)
                    if index % 2 == 0 {
                        if index == 0 {
                            elementData += stringArray
                            elementData += ["", "", "", ""]
                            numberOfCoir = ((stringArray.count - 1)/coirHeadings) + 1
                        } else { elementData += stringArray }
                    }
                    else { quantityData += stringArray}
                }
            }
            coirData = convertToCoirData(withElements: elementData, andQuantity: quantityData, with: numberOfCoir)
        }
        coirDataRecievedFlag = true
    }
    
    @objc func detailDataResult(ticket: GTLRServiceTicket, data : GTLRSheets_Spreadsheet, error : NSError?) {
        //print(data.sheets![0].data![0].rowData![0].values![0].formattedValue)
        var inData: [CoirDetailData] = []
        var outData: [CoirDetailData] = []
        if let recievedData = data.sheets![0].data {
            for index in 0..<recievedData.count {
                if let rowData = recievedData[index].rowData {
                    var rowNumber: Int = 0
                    for row in rowData {
                        if let cell = row.values {
                            switch index {
                            case 0:
                                inData.append(CoirDetailData(name: nil, date: nil, quantity: Int(cell[0].formattedValue!)))
                            case 1:
                                inData[rowNumber].name = cell[0].note
                                inData[rowNumber].date = cell[0].formattedValue
                            case 2:
                                outData.append(CoirDetailData(name: nil, date: nil, quantity: Int(cell[0].formattedValue!)! * -1))
                            case 3:
                                outData[rowNumber].name = cell[0].note
                                outData[rowNumber].date = cell[0].formattedValue
                            default: break
                            }
                        }
                        rowNumber += 1
                    }
                }
            }
        }
        coirDetailData = inData + outData
        coirDetailData.sort {
            $0.unixTime! < $1.unixTime!
        }
        coirDetailDataRecievedFlag = true
    }
    
    private func convertToCoirData(withElements elements: [String], andQuantity quantity: [String], with numberOfCoir: Int) -> [CoirData] {
        var coirDataToReturn: [CoirData] = []
        var isCoir: Bool = true
        let totalNumber = ((elements.count - 1)/coirHeadings) + 1
        for count in 0..<totalNumber {
            if count >= numberOfCoir { isCoir = false }
            let element = elements[count * coirHeadings]
            let quantity = Int(quantity[4 + (count * coirHeadings)])
            coirDataToReturn.append(CoirData(element: element, quantity: quantity!, isCoir: isCoir))
        }
        return coirDataToReturn
    }
    
    private func convertToStringArray(for recievedData: [[Any]]) -> [String] {
        var finalStringArray: [String] = []
        for count in 0..<recievedData[0].count {
            if let element = recievedData[0][count] as? String {
                finalStringArray.append(element)
            }
        }
        return deleteExcess(from: finalStringArray)
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
    
    private func convertToAlphabet(withNumber colNumber: Int) -> String {
        let letterA: Character = "A"
        var stringToReturn: String = ""
        var number = colNumber
        while number > 0 {
            var reminder: Int = number % 26
            if reminder == 0 { reminder = 26 }
            let colLetter = String(UnicodeScalar((letterA.asciiValue! + UInt8(reminder - 1))))
            stringToReturn = colLetter + stringToReturn
            number = Int((number-1) / 26)
        }
        return stringToReturn
    }
}

struct CoirData {
    var element: String
    var quantity: Int
    var isCoir: Bool
}

struct CoirDetailData {
    var name: String?
    var date: String? {
        didSet { getDate() }
    }
    var quantity: Int?
    var unixTime: TimeInterval?
    
    mutating private func getDate() {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "MM/dd/yyyy HH:mm:ss"
        let formattedDate = dateFormatterGet.date(from: date! + " 00:00:00")
        unixTime = formattedDate?.timeIntervalSince1970
    }
}


