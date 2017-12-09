//
//  ObjectJsionHandler.swift
//  SuperVarioWohnenServerPackageDescription
//
//  Created by Tobias on 07.12.17.
//

import Foundation
import SwiftyJSON
import MySQL

extension HouseObject {
    func toJson(connection: ConnectionPool) -> JSON {
        let categories = ForumCategory.getCategories(objectId: id, connection: connection)
        var categoriesJson = [[String: Any]]()
        
        for category in categories {
            categoriesJson.append([
                "id" : category.id,
                "name": category.name
                ])
        }
        
        let json = JSON([
            "id": id,
            "street": street,
            "place": place,
            "postcode": postcode,
            "forumCategories": categoriesJson
            ])
        return json
    }
    
    static func fromJson(json: JSON) -> HouseObject {
        return HouseObject(
            id: json["id"].intValue,
            street: json["street"].stringValue,
            place: json["place"].stringValue,
            postcode: json["postcode"].stringValue,
            managementId: 0
        )
    }
}
