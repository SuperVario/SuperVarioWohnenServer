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
    var documentId: String
    
    var tenantId: Int
    
    var name: String
    var folder: String
    
    static func decodeRow(r: QueryRowResult) throws -> Document {
        return try Document(
            id: r <| "id",
            documentId: r <| "document_id",
            tenantId: r <| "tenant_id",
            name: r <| "name",
            folder:  r <| "folder"
        )
    }
    
    func queryParameter() throws -> QueryDictionary {
        return QueryDictionary([
            "name": name,
            "document_id": documentId,
            "tenant_id": tenantId,
            "folder": folder
        ])
    }
}
