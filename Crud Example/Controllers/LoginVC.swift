//
//  LoginV.swift
//  Crud Example
//
//  Created by Genesis Vargas on 24/11/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginVC: UIViewController {
    
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPassword: UITextField!
    
    let prefs = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        if(self.txtPassword.text == "" || self.txtEmail.text == ""){
            Message().showMsg(controller: self, msg: Constants.MESSAGE_NO_COMPLETE)
        }else{
            self.login()
        }
    }
    
    func login() {
        if Connectivity.isConnectedToInternet() == true {
            self.showSpinner()
            let params: [String: Any] = ["email": self.txtEmail.text, "password": self.txtPassword.text]
            AF.request(Constants.API.VERIFY_URL, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
                self.removeSpinner()
                switch (response.result) {
                    case .success(let value):
                        let jsonData = JSON(value)
                        if response.response?.statusCode == 200 {
                            let token = jsonData["token"].string!
                            let id = jsonData["id"].int!
                            self.prefs.set(id, forKey: "USER_ID")
                            self.prefs.set(token, forKey: "USER_TOKEN")
                            self.prefs.set(1, forKey: "ISLOGGEDIN")
                            self.dismiss(animated: true, completion: nil)
                            _ = self.navigationController?.popToRootViewController(animated: true)
                        }else{
                            let message = jsonData["message"].string!
                            Message().showMsg(controller: self, msg: message)
                        }
                        break
                    case .failure(let error):
                        Message().showMsg(controller: self, msg: error.localizedDescription)
                        break
                }
            }
        }else{
            Message().showMsg(controller: self, msg: Constants.MESSAGE_NO_INTERNET)
        }
    }
}
