//
//  File.swift
//  SuperVarioWohnenServerPackageDescription
//
//  Created by Tobias on 11.11.17.
//

import Foundation
import MySQL

struct Tenant: QueryRowResultType, QueryParameterDictionaryType {
    var id: Int
    var name: String
    var lastName: String
    
    var telefon: String
    var mail: String
    
    var qrcode: String
    
    
    static func decodeRow(r: QueryRowResult) throws -> Tenant {
        return try Tenant(
            id: r <| "id",
            name: r <| "name",
            lastName: r <| "last_name",
            
            telefon: r <| "telefon",
            mail: r <| "mail",
            
            qrcode: r <| "qrcode"
        )
    }
    
    func queryParameter() throws -> QueryDictionary {
        return QueryDictionary([
            "name": name,
            "last_name": lastName,
            
            "telefon": telefon,
            "mail": mail,
            
            "qrcode": qrcode
        ])
    }
}
