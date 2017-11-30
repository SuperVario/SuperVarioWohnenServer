//
//  BoardEntry.swift
//  SuperVarioWohnenServerPackageDescription
//
//  Created by Tobias on 11.11.17.
//

import Foundation
import MySQL

struct BoardEntry: QueryRowResultType, QueryParameterDictionaryType {
    var id: Int
    var title: String
    var message: String
    
    var createDate: Date
    var expireDate: Date?
    
    
    static func decodeRow(r: QueryRowResult) throws -> BoardEntry {
        return try BoardEntry(
            id: r <| "id",
            title: r <| "title",
            message: r <| "message",
            
            createDate: Date(), // TODO
            expireDate: nil
        )
    }
    
    func queryParameter() throws -> QueryDictionary {
        return QueryDictionary([
            "title": title,
            "message": message,
            
            "create_date": createDate,
            "exipre_date": expireDate
        ])
    }
}
