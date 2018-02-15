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
    var openings_weekdays: String
    var openings_weekends: String
    var website: String
    
    static func decodeRow(r: QueryRowResult) throws -> Management {
        return try Management(
            id: r <| "id",
            name: r <| "name",
            
            street: r <| "street",
            place: r <| "place",
            postcode: r <| "postcode",
            
            telefon: r <| "telefon",
            mail: r <| "mail",
            
            openings_weekdays: r <| "openings_weekdays",
            openings_weekends: r <| "openings_weekends",
            website: r <| "website"
            
        )
    }
    
    func queryParameter() throws -> QueryDictionary {
        return QueryDictionary([
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
    }
}
