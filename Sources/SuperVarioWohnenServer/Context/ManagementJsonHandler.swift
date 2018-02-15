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
        
        let json = JSON([
            "id": id,
            "name": name,
            "street": street,
            "place": place,
            "postcode": postcode,
            "telefon": telefon,
            "mail": mail ?? nil,
            "openings_weekdays": openings_weekdays ?? nil,
            "openings_weekends": openings_weekends ?? nil,
            "website": website ?? nil
            
            ])
        return json
    }
    
    static func fromJson(json: JSON) -> Management {
        let mail = json["mail"].string
        let o1 = json["openings_weekdays"].string
        let o2 = json["openings_weekends"].string
        let website = json["website"].string
        return Management(
            id: json["id"].intValue,
            name: json["name"].stringValue,
            street: json["street"].stringValue,
            place: json["place"].stringValue,
            postcode: json["postcode"].stringValue,
            telefon: json["telefon"].stringValue,
            mail: mail,
            openings_weekdays: o1,
            openings_weekends: o2,
            website: website
        )
    }
}
