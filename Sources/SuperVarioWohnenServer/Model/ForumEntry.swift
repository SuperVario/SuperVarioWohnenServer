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
    
    var tenantId: Int
    var categoryId: Int
 
    static func decodeRow(r: QueryRowResult) throws -> ForumEntry {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        
        return try ForumEntry(
            id: r <| "id",
            title: r <| "title",
            message: r <| "message",
            date: dateFormatter.date(from: r <| "date") ?? Date(),
            
            tenantId: r <| "tenant_id",
            categoryId: r <| "category_id"
        )
    }
    
    func queryParameter() throws -> QueryDictionary {
        return QueryDictionary([
            "title": title,
            "message": message,
            "date": date.description,
            
            "tenant_id": tenantId,
            "category_id": categoryId
        ])
    }
}
