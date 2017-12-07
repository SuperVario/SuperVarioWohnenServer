//
//  HouseObject.swift
//  SuperVarioWohnenServerPackageDescription
//
//  Created by Tobias on 11.11.17.
//

import Foundation
import MySQL

struct HouseObject: QueryRowResultType, QueryParameterDictionaryType {
    var id: Int
    
    var street: String
    var place: String
    var postcode: String
    
    var managementId: Int
    
    static func decodeRow(r: QueryRowResult) throws -> HouseObject {
        return try HouseObject(
            id: r <| "id",
            
            street: r <| "street",
            place: r <| "place",
            postcode: r <| "postcode",
            
            managementId :  r <| "management_id"
        )
    }
    
    func queryParameter() throws -> QueryDictionary {
        return QueryDictionary([
            "street": street,
            "place": place,
            "postcode": postcode,
            "management_id": managementId
        ])
    }
}
