//
//  DocumentJsonHandler.swift
//  SuperVarioWohnenServerPackageDescription
//
//  Created by Tobias on 30.11.17.
//

import Foundation
import SwiftyJSON

extension Document {
    func toJson() -> JSON {
        let json = JSON([
            "id": id,
            "name": name,
            "description": description,
            "folder": folder,
            ])
        return json
    }
}
