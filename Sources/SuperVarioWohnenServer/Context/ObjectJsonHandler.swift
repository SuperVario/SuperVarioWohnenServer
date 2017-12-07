//
//  ObjectJsionHandler.swift
//  SuperVarioWohnenServerPackageDescription
//
//  Created by Tobias on 07.12.17.
//

import Foundation
import SwiftyJSON

extension HouseObject {
    func toJson() -> JSON {
        let json = JSON([
            "id": id,
            "street": street,
            "place": place,
            "postcode": postcode
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
