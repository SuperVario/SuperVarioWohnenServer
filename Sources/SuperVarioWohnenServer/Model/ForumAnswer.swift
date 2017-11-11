//
//  ForumAnswer.swift
//  SuperVarioWohnenServerPackageDescription
//
//  Created by Tobias on 11.11.17.
//

import Foundation
import MySQL

struct ForumAnswer: QueryRowResultType, QueryParameterDictionaryType {
    var id: Int
    var message: String
    var date: Date
    
    
    static func decodeRow(r: QueryRowResult) throws -> ForumAnswer {
        return try ForumAnswer(
            id: r <| "id",
            message: r <| "message",
            date: r <| "date"
        )
    }
    
    func queryParameter() throws -> QueryDictionary {
        return QueryDictionary([
            "message": message,
            "date": date
        ])
    }
}
