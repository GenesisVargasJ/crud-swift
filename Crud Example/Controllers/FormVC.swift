//
//  FormVC.swift
//  Crud Example
//
//  Created by Genesis Vargas on 24/11/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class FormVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtLastname: UITextField!
    @IBOutlet var txtIdentification: UITextField!
    @IBOutlet var txtBirthDate: UITextField!
    @IBOutlet var txtGender: UITextField!
    @IBOutlet var txtPhone: UITextField!
    @IBOutlet var txtAddress: UITextField!
    @IBOutlet var txtCity: UITextField!
    @IBOutlet var txtProfession: UITextField!
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var btnDelete: UIBarButtonItem!
    
    var pckProfession = UIPickerView()
    var pckCity = UIPickerView()
    var pckGender = UIPickerView()
    var datepicker = UIDatePicker()
    var professions = [Generic]()
    var cities = [Generic]()
    var genders = [Generic]()
    let prefs = UserDefaults.standard
    var id = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        self.loadData(type: 0)
        self.loadData(type: 1)
        self.loadData(type: 2)
        if id != 0 {
            self.navigationItem.title = "Edicion"
            self.btnSave.setTitle("Editar", for: .normal)
            self.btnDelete.isEnabled = true
        }else{
            self.navigationItem.title = "Registro"
            self.btnSave.setTitle("Registrar", for: .normal)
            self.btnDelete.isEnabled = false
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return self.professions.count
        case 2:
            return self.cities.count
        case 3:
            return self.genders.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return self.professions[row].name
        case 2:
            return self.cities[row].name
        case 3:
            return self.genders[row].name
        default:
            return "No encontrado"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            self.txtProfession.text = self.professions[row].name
            self.txtProfession.resignFirstResponder()
        case 2:
            self.txtCity.text = self.cities[row].name
            self.txtCity.resignFirstResponder()
        case 3:
            self.txtGender.text = self.genders[row].name
            self.txtGender.resignFirstResponder()
        default:
            return
        }
    }
    
    @IBAction func btnSave(_ sender: Any) {
        if(self.txtName.text == "" || self.txtLastname.text == "" || self.txtGender.text == "" || self.txtProfession.text == "" || self.txtCity.text == "") {
            Message().showMsg(controller: self, msg: Constants.MESSAGE_NO_COMPLETE)
        }else{
            self.saveData()
        }
    }
    
    @IBAction func btnDelete(_ sender: Any) {
        self.deleteData()
    }
    
    func createPickerViews() {
        self.txtProfession.inputView = self.pckProfession
        self.pckProfession.delegate = self
        self.pckProfession.dataSource = self
        self.pckProfession.tag = 1
        self.txtCity.inputView = self.pckCity
        self.pckCity.delegate = self
        self.pckCity.dataSource = self
        self.pckCity.tag = 2
        self.txtGender.inputView = self.pckGender
        self.pckGender.delegate = self
        self.pckGender.dataSource = self
        self.pckGender.tag = 3
    }
    
    func createDatePickerViews() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.handleDoneButton))
        toolbar.setItems([doneBtn], animated: true)
        self.datepicker.datePickerMode = .date
        self.datepicker.preferredDatePickerStyle = .wheels
        self.txtBirthDate.inputAccessoryView = toolbar
        self.txtBirthDate.inputView = datepicker
    }
    
    @objc func handleDoneButton() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if self.txtBirthDate.isFirstResponder {
            self.txtBirthDate.text = formatter.string(from: self.datepicker.date)
        }
        self.view.endEditing(true)
    }
        
    
    func loadData(type: Int) {
        if type == 2 {
            let item1 = Generic()
            item1.id = 0
            item1.name = "Desconocido"
            self.genders.append(item1)
            let item2 = Generic()
            item2.id = 1
            item2.name = "Hombre"
            self.genders.append(item2)
            let item3 = Generic()
            item3.id = 2
            item3.name = "Mujer"
            self.genders.append(item3)
            let item4 = Generic()
            item4.id = 9
            item4.name = "No aplica"
            self.genders.append(item4)
            self.createPickerViews()
            self.createDatePickerViews()
            if id != 0 {
                self.getPerson(id: id)
            }
        }else{
            if Connectivity.isConnectedToInternet() == true {
                var url = ""
                var key = ""
                if type == 0 {
                    url = Constants.API.PROFESSIONS_URL
                    key = "professions"
                }else{
                    url = Constants.API.CITIES_URL
                    key = "cities"
                }
                AF.request(url, method: .get, headers: Constants.API.getHeaders(prefs: self.prefs)).responseJSON { response in
                    switch (response.result) {
                        case .success(let value):
                            let jsonData = JSON(value)
                            if response.response?.statusCode == 200 {
                                for generic in jsonData[key].arrayValue {
                                    let item = Generic()
                                    item.id = generic["id"].int!
                                    item.name = generic["name"].string!
                                    if type == 0 {
                                        self.professions.append(item)
                                    }else{
                                        self.cities.append(item)
                                    }
                                }
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
    
    func getPerson(id: Int) {
        if Connectivity.isConnectedToInternet() == true {
            self.showSpinner()
            AF.request(Constants.API.PERSONS_URL + "/\(id)", method: .get, headers: Constants.API.getHeaders(prefs: self.prefs)).responseJSON { response in
                self.removeSpinner()
                switch (response.result) {
                    case .success(let value):
                        let jsonData = JSON(value)
                        if response.response?.statusCode == 200 {
                            let person = jsonData["person"]
                            self.txtName.text = person["name"].string
                            self.txtLastname.text = person["lastname"].string
                            self.txtIdentification.text = person["identification"].string
                            self.txtBirthDate.text = person["birth_date"].string
                            self.txtGender.text = self.genders.first(where: { value -> Bool in value.id == person["gender"].int })!.name
                            self.txtPhone.text = person["phone"].string
                            self.txtAddress.text = person["address"].string
                            self.txtCity.text = self.cities.first(where: { value -> Bool in value.id == person["id_city"].int })!.name
                            self.txtProfession.text = self.professions.first(where: { value -> Bool in value.id == person["id_profession"].int })!.name
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
    
    func saveData() {
        if Connectivity.isConnectedToInternet() == true {
            self.showSpinner()
            let id_profession = professions.first(where: { value -> Bool in value.name == self.txtProfession.text })!.id!
            let id_city = cities.first(where: { value -> Bool in value.name == self.txtCity.text })!.id!
            let gender = genders.first(where: { value -> Bool in value.name == self.txtGender.text })!.id!
            let params: [String: Any] = ["name": self.txtName.text, "lastname": self.txtLastname.text, "identification": self.txtIdentification.text, "birth_date": self.txtBirthDate.text, "gender": gender, "phone": self.txtPhone.text, "address": self.txtAddress.text, "id_city": id_city, "id_profession": id_profession]
            var url = Constants.API.PERSONS_URL
            var method: HTTPMethod = .post
            if id != 0 {
                url = Constants.API.PERSONS_URL + "/\(id)"
                method = .put
            }
            AF.request(url, method: method, parameters: params, encoding: JSONEncoding.default, headers: Constants.API.getHeaders(prefs: self.prefs)).responseJSON { response in
                self.removeSpinner()
                switch (response.result) {
                    case .success(let value):
                        let jsonData = JSON(value)
                        if response.response?.statusCode == 201 {
                            self.txtName.text = ""
                            self.txtLastname.text = ""
                            self.txtIdentification.text = ""
                            self.txtBirthDate.text = ""
                            self.txtGender.text = ""
                            self.txtPhone.text = ""
                            self.txtAddress.text = ""
                            self.txtCity.text = ""
                            self.txtProfession.text = ""
                            Message().showMsg(controller: self, msg: Constants.MESSAGE_REGISTER)
                        }else if response.response?.statusCode == 204 {
                            Message().showMsg(controller: self, msg: Constants.MESSAGE_EDIT)
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
    
    func deleteData() {
        let alertController = UIAlertController(title: Constants.APP_NAME, message: Constants.MESSAGE_DELETE, preferredStyle: UIAlertController.Style.actionSheet)
        let OKAction = UIAlertAction(title: "Si", style: .default) { (action:UIAlertAction!) in
            AF.request(Constants.API.PERSONS_URL + "/\(self.id)", method: .delete, headers: Constants.API.getHeaders(prefs: self.prefs)).responseJSON { response in
                switch (response.result) {
                    case .success(let value):
                        let jsonData = JSON(value)
                        if response.response?.statusCode == 204 {
                            self.navigationController?.popViewController(animated: true)
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
        }
        let CancelAction = UIAlertAction(title: "No", style: .default) { (action:UIAlertAction!) in
            print("nothing");
        }
        alertController.addAction(OKAction)
        alertController.addAction(CancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
