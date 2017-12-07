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
    
    var objectId: Int
    
    static func decodeRow(r: QueryRowResult) throws -> BoardEntry {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        
        return try BoardEntry(
            id: r <| "id",
            title: r <| "title",
            message: r <| "message",

            createDate: dateFormatter.date(from: r <| "create_date") ?? Date(),
            expireDate: dateFormatter.date(from: (r <|? "expire_date") ?? "") ?? nil,
            
            objectId: r <| "object_id"
        )
    }
    
    func queryParameter() throws -> QueryDictionary {
        return QueryDictionary([
            "title": title,
            "message": message,
            
            "create_date": createDate.description,
            "expire_date": expireDate?.description,
            
            "object_id": objectId
        ])
    }
}
