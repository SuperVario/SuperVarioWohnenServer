//
//  Tenant.swift
//  SuperVarioWohnenServer
//
//  Created by Tobias on 17.11.17.
//

import Foundation
import Kitura
import SwiftyJSON

class TenantContext {
    func getTenant(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) -> Void {
        // Input auswerten
        
        // Datenbank anfrage
        let tenant = Tenant(id: 1, name: "max", lastName: "Mustermann", telefon: "0217437382", mail: "test@example.com", qrcode: "bfiwenoMPA")
        
        var array = [JSON]()
        array.append(tenant.toJson())
        array.append(tenant.toJson())
        array.append(tenant.toJson())
        
        // Repsonse senden
        response.status(.OK).send(json: JSON(array))
        next()
    }
}
