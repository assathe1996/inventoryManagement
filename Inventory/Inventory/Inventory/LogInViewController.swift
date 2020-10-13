//
//  LogInViewController.swift
//  Inventory
//
//  Created by Atharv Sathe on 18/08/19.
//  Copyright © 2019 Atharv Sathe. All rights reserved.
//  https://docs.google.com/spreadsheets/d/1N9j2c0ETbLm3a42dJVus4WUBObjRwY3iXlPB9PMTE4c/edit#gid=0

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST

class LogInViewController: UIViewController {
    fileprivate var sheetAPIs: sheetAPI?
    var temp: [[Any]] = [[]]
    
    @IBAction func Press(_ sender: UIButton) {
        //sheetAPIs?.getDetailCoirData(from: "1N9j2c0ETbLm3a42dJVus4WUBObjRwY3iXlPB9PMTE4c", forSize: 1)
        //sheetAPIs?.getCoirData(from: "1N9j2c0ETbLm3a42dJVus4WUBObjRwY3iXlPB9PMTE4c")
        //sheetAPIs?.getData(from: "1N9j2c0ETbLm3a42dJVus4WUBObjRwY3iXlPB9PMTE4c", at: "Coir!A1:AZ1")
        //print("KI")
    }
    
    private func setupGoogleSignIn() {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = [kGTLRAuthScopeSheetsSpreadsheetsReadonly]
        GIDSignIn.sharedInstance()?.signInSilently()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupGoogleSignIn()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "GoToTabView" {
            if let tabView = segue.destination as? TabViewController {
                tabView.sheetAPIs = sheetAPIs
            }
        }
    }
}

extension LogInViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let _ = error {
        } else {
            print("Authenticate successfully")
            let service = GTLRSheetsService()
            service.authorizer = user.authentication.fetcherAuthorizer()
            self.sheetAPIs = sheetAPI(service: service)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Did disconnect to user")
    }
}

extension LogInViewController: GIDSignInUIDelegate {}
