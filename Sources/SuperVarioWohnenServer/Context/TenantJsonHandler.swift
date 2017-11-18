//
//  TenantJsonHandler.swift
//  SuperVarioWohnenServerPackageDescription
//
//  Created by Tobias on 18.11.17.
//

import Foundation
import SwiftyJSON

extension Tenant {
    func toJson() -> JSON {
        let json = JSON([
            "id": id,
            "firstName": name,
            "lastName": lastName,
            "tel": telefon,
            "mail": mail,
            "qrcode_data": qrcode
        ])
        return json
    }
}
