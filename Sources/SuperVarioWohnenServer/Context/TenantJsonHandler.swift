//
//  TenantJsonHandler.swift
//  SuperVarioWohnenServerPackageDescription
//
//  Created by Tobias on 18.11.17.
//

import Foundation
import SwiftyJSON

extension Tenant {
    func toJson() -> JSON {
        let json = JSON([
            "id": id,
            "firstName": name,
            "lastName": lastName,
            "tel": telefon,
            "mail": mail,
            "qrcode_data": qrcode
        ])
        return json
    }
    
    static func fromJson(json: JSON) -> Tenant {
        return Tenant(
            id: json["id"].intValue,
            name: json["firstName"].stringValue,
            lastName: json["lastName"].stringValue,
            
            telefon: json["tel"].stringValue,
            mail: json["mail"].stringValue,
            
            qrcode: json["qrcode_data"].stringValue,
            
            objectId: json["objectId"].intValue
        )
    }
}
