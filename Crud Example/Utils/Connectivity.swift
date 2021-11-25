//
//  Connectivity.swift
//  Crud Example
//
//  Created by Genesis Vargas on 24/11/21.
//

import Foundation
import Alamofire

class Connectivity{
    
    class func isConnectedToInternet()->Bool{
        return NetworkReachabilityManager()!.isReachable
    }
}
