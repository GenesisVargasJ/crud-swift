//
//  ViewController.swift
//  Crud Example
//
//  Created by Genesis Vargas on 24/11/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    let prefs = UserDefaults.standard
    var personList = [Person]()
    var id = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let isLoggedIn:Int = self.prefs.integer(forKey: "ISLOGGEDIN") as Int
        if (isLoggedIn != 1) {
            self.performSegue(withIdentifier: "goto_login", sender: self)
        }else{
            self.getPersons()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! FormVC
        nextVC.id = self.id
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.personList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let person = self.personList[indexPath.row]
        cell.textLabel?.text = person.name! + " " + person.lastname!
        cell.detailTextLabel?.text = "\(person.identification!)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.id = self.personList[indexPath.row].id!
        self.performSegue(withIdentifier: "goto_form", sender: self)
    }
    
    @IBAction func btnAdd(_ sender: Any) {
        self.id = 0
        self.performSegue(withIdentifier: "goto_form", sender: self)
    }
    
    func getPersons() {
        if Connectivity.isConnectedToInternet() == true {
            self.showSpinner()
            AF.request(Constants.API.PERSONS_URL, method: .get, headers: Constants.API.getHeaders(prefs: self.prefs)).responseJSON { response in
                self.removeSpinner()
                switch (response.result) {
                    case .success(let value):
                        let jsonData = JSON(value)
                        if response.response?.statusCode == 200 {
                            self.personList.removeAll()
                            for person in jsonData["persons"].arrayValue {
                                let item = Person()
                                item.id = person["id"].int
                                item.name = person["name"].string
                                item.lastname = person["lastname"].string
                                item.identification = person["identification"].string
                                self.personList.append(item)
                            }
                            self.tableView.reloadData()
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
