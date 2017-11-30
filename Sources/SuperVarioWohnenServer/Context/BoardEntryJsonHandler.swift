//
//  BoardEntryJsonHandler.swift
//  SuperVarioWohnenServer
//
//  Created by Tobias on 30.11.17.
//

import Foundation
import SwiftyJSON

extension BoardEntry {
    func toJson() -> JSON {
        let json = JSON([
            "id": id,
            "title": title,
            "message": message,
            
            "createDate": createDate.description
        ])

        return json
    }
    
    static func fromJson(json: JSON) -> BoardEntry {
        return BoardEntry(
            id: json["id"].intValue,
            title: json["title"].stringValue,
            message: json["message"].stringValue,
            createDate: Date(), // TODO
            expireDate: nil
        )
    }
}
