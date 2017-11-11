//
//  Management.swift
//  SuperVarioWohnenServerPackageDescription
//
//  Created by Tobias on 11.11.17.
//

import Foundation
import MySQL

struct Management: QueryRowResultType, QueryParameterDictionaryType {
    var id: Int
    var name: String
    
    var street: String
    var place: String
    var postcode: String
    
    var telefon: String
    var mail: String
    
    static func decodeRow(r: QueryRowResult) throws -> Management {
        return try Management(
            id: r <| "id",
            name: r <| "name",
            
            street: r <| "street",
            place: r <| "place",
            postcode: r <| "postcode",
            
            telefon: r <| "telefon",
            mail: r <| "mail"
        )
    }
    
    func queryParameter() throws -> QueryDictionary {
        return QueryDictionary([
            "name": name,
            
            "street": street,
            "place": place,
            "postcode": postcode,
            
            "telefon": telefon,
            "mail": mail
        ])
    }
}
