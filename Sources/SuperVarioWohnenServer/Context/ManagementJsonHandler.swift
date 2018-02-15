//
//  ManagementJsonHandler.swift
//  SuperVarioWohnenServerPackageDescription
//
//  Created by Max Bause on 04.01.18.
//

import Foundation
import SwiftyJSON
import MySQL

extension Management{
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
            "name": name,
            "street": street,
            "place": place,
            "postcode": postcode,
            "telefon": telefon,
            "mail": mail,
            "openings_weekdays": openings_weekdays,
            "openings_weekends": openings_weekends,
            "website": website
            
            ])
        return json
    }
    
    static func fromJson(json: JSON) -> Management {
        return Management(
            id: json["id"].intValue,
            name: json["name"].stringValue,
            street: json["street"].stringValue,
            place: json["place"].stringValue,
            postcode: json["postcode"].stringValue,
            telefon: json["telefon"].stringValue,
            mail: json["mail"].stringValue,
            openings_weekdays: json["openings_weekdays"].stringValue,
            openings_weekends: json["openings_weekends"].stringValue,
            website: json["website"].stringValue
        )
    }
}
