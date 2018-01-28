//
//  ForumJsonHandler.swift
//  SuperVarioWohnenServerPackageDescription
//
//  Created by Tobias on 07.12.17.
//

import Foundation
import SwiftyJSON
import MySQL

extension ForumCategory {
    func toJson() -> JSON {
        let json = JSON([
            "id": id,
            "name": name
            ])
        return json
    }
}

extension ForumEntry {
    func toJson(connection: ConnectionPool) -> JSON {
        let tenant = Tenant.getById(id: tenantId, connection: connection)
        let json = JSON([
            "id": id,
            "title": title,
            "message": message,
            "date": date.description,
            "tenant": [
                "id": tenantId,
                "name": tenant?.name ?? "",
                "lastName": tenant?.lastName ?? ""
            ]
            ])
        return json
    }
    
    static func fromJson(json: JSON) -> ForumEntry {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        
        return ForumEntry(
            id: json["id"].intValue,
            title: json["title"].stringValue,
            message: json["message"].stringValue,
            date: dateFormatter.date(from: json["date"].stringValue) ?? Date(),
            
            tenantId: json["tenantId"].intValue,
            categoryId: json["categoryId"].intValue
        )
    }
}

extension ForumAnswer {
    func toJson(connection: ConnectionPool) -> JSON {
        let tenant = Tenant.getById(id: id, connection: connection)
        let json = JSON([
            "id": id,
            "message": message,
            "date": date.description,
            "tenant": [
                "id": tenantId,
                "name": tenant?.name ?? "",
                "lastName": tenant?.lastName ?? ""
            ]
            ])
        return json
    }
    
    static func fromJson(json: JSON) -> ForumAnswer {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        
        return ForumAnswer(
            id: json["id"].intValue,
            message: json["message"].stringValue,
            date: dateFormatter.date(from: json["date"].stringValue) ?? Date(),
            
            tenantId: json["tenantId"].intValue,
            entryId: json["entryId"].intValue
        )
    }
}
