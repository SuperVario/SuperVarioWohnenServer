//
//  Document.swift
//  SuperVarioWohnenServerPackageDescription
//
//  Created by Tobias on 11.11.17.
//

import Foundation
import MySQL

struct Document: QueryRowResultType, QueryParameterDictionaryType {
    var id: Int
    
    var name: String
    var description: String
    var filename: String
    
    static func decodeRow(r: QueryRowResult) throws -> Document {
        return try Document(
            id: r <| "id",
            name: r <| "name",
            description: r <| "description",
            filename: r <| "filename"
        )
    }
    
    func queryParameter() throws -> QueryDictionary {
        return QueryDictionary([
            "name": name,
            "description": description,
            "filename": filename
        ])
    }
}