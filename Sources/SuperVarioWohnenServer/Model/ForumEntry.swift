//
//  ForumEntry.swift
//  SuperVarioWohnenServerPackageDescription
//
//  Created by Tobias on 11.11.17.
//

import Foundation
import MySQL

struct ForumEntry: QueryRowResultType, QueryParameterDictionaryType {
    var id: Int
    var title: String
    var message: String
    var date: Date
 
    static func decodeRow(r: QueryRowResult) throws -> ForumEntry {
        return try ForumEntry(
            id: r <| "id",
            title: r <| "title",
            message: r <| "message",
            date: r <| "date"
        )
    }
    
    func queryParameter() throws -> QueryDictionary {
        return QueryDictionary([
            "title": title,
            "message": message,
            "date": date
        ])
    }
}
