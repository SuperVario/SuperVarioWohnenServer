//
//  ForumCategory.swift
//  SuperVarioWohnenServerPackageDescription
//
//  Created by Tobias on 11.11.17.
//

import Foundation
import MySQL

struct ForumCategory: QueryRowResultType, QueryParameterDictionaryType {
    var id: Int
    var name: String
    
    
    static func decodeRow(r: QueryRowResult) throws -> ForumCategory {
        return try ForumCategory(
            id: r <| "id",
            name: r <| "name"
        )
    }
    
    func queryParameter() throws -> QueryDictionary {
        return QueryDictionary([
            "name": name
        ])
    }
}
