//
//  UIViewController.swift
//  Crud Example
//
//  Created by Genesis Vargas on 24/11/21.
//

import Foundation
import UIKit

fileprivate var aView : UIView?

extension UIViewController{
    
    func showSpinner(){
        
        aView = UIView(frame: self.view.bounds)
        aView?.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        ai.center = aView!.center
        ai.startAnimating()
        aView?.addSubview(ai)
        self.view.addSubview(aView!)
    }
    
    func removeSpinner(){
        aView?.removeFromSuperview()
        aView = nil
    }
    
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
