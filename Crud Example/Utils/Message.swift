//
//  Message.swift
//  Crud Example
//
//  Created by Genesis Vargas on 24/11/21.
//

import Foundation
import UIKit

class Message {
    
    func showMsg(controller: UIViewController, msg: String) {
        let alertController = UIAlertController(title: "CRUD Example", message: msg, preferredStyle: UIAlertController.Style.alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        controller.present(alertController, animated: true, completion: nil)
    }
}
