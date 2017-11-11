//
//  Staff.swift
//  SuperVarioWohnenServerPackageDescription
//
//  Created by Tobias on 11.11.17.
//

import Foundation
import MySQL

struct Staff: QueryRowResultType, QueryParameterDictionaryType {
    var id: Int
    
    var name: String
    var lastName: String
    
    var password: String
    
    var telefon: String
    var mail: String
    
    static func decodeRow(r: QueryRowResult) throws -> Staff {
        return try Staff(
            id: r <| "id",
            name: r <| "name",
            lastName: r <| "last_name",
            
            password: r <| "password",
            
            telefon: r <| "telefon",
            mail: r <| "mail"
        )
    }
    
    func queryParameter() throws -> QueryDictionary {
        return QueryDictionary([
            "name": name,
            "last_name": lastName,
            
            "password": password,
            
            "telefon": telefon,
            "mail": mail
        ])
    }
}
