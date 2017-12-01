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
    
    var username: String
    var password: String
    
    var session: String?
    
    var telefon: String
    var mail: String
    
    static func decodeRow(r: QueryRowResult) throws -> Staff {
        return try Staff(
            id: r <| "id",
            
            name: r <| "name",
            lastName: r <| "last_name",
            
            username: r <| "username",
            password: r <| "password",
            session: r <|? "session",
            
            telefon: r <| "telefon",
            mail: ""
        )
    }
    
    func queryParameter() throws -> QueryDictionary {
        return QueryDictionary([
            "name": name,
            "last_name": lastName,
            
            "uswername": username,
            "password": password,
            "session": session,
            
            "telefon": telefon,
            "mail": mail
        ])
    }
}

extension Staff {
    static func getStaffBySession(session: String, connection: ConnectionPool) throws -> Staff? {
        let params = build((session))
        let staff: [Staff] = try connection.execute { try $0.query("SELECT * FROM Staff WHERE session = ?;", params) }
        if let first = staff.first {
            return first
        }
        return nil
    }
}
