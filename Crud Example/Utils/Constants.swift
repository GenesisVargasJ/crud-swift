//
//  Constants.swift
//  Crud Example
//
//  Created by Genesis Vargas on 24/11/21.
//

import Foundation
import Alamofire

struct Constants {
    
    static let APP_NAME = "Crud Example"
    static let MESSAGE_NO_INTERNET = "Te has quedado sin internet"
    static let MESSAGE_NO_COMPLETE = "Completa los datos"
    static let MESSAGE_REGISTER = "Se ha registrado exitosamente"
    static let MESSAGE_EDIT = "Se ha editado exitosamente"
    static let MESSAGE_DELETE = "Desea eliminar esto?"

    struct API {
        
        static let VERIFY_URL = "http://192.168.10.2:3000/api/v1/login"
        static let PERSONS_URL = "http://192.168.10.2:3000/api/v1/persons"
        static let PROFESSIONS_URL = "http://192.168.10.2:3000/api/v1/professions"
        static let CITIES_URL = "http://192.168.10.2:3000/api/v1/cities"
        static func getHeaders(prefs: UserDefaults) -> HTTPHeaders {
            return [
                "Authorization": "Bearer " + prefs.string(forKey: "USER_TOKEN")!,
                "userid": prefs.string(forKey: "USER_ID")!
            ]
        }
    }
}
