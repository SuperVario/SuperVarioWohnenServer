//
//  TenantJsonHandler.swift
//  SuperVarioWohnenServerPackageDescription
//
//  Created by Tobias on 18.11.17.
//

import Foundation
import SwiftyJSON
import MySQL

extension Tenant {
    func toJson(connection: ConnectionPool) -> JSON {
        let documents = Document.getDocuments(tenantId: id, connection: connection)
        var documentJsonArray = [[String: Any]]()
        
        for document in documents {
            documentJsonArray.append([
                "id" : document.id,
                "name" : document.name,
                "folder": document.folder
                ])
        }
        
        let json = JSON([
            "id": id,
            "firstName": name,
            "lastName": lastName,
            "tel": telefon,
            "mail": mail,
            "qrcode_data": qrcode,
            "documents": documentJsonArray
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
            active: json["active"].boolValue,
            
            objectId: json["objectId"].intValue
        )
    }
}
