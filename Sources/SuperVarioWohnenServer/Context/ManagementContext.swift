//
//  ManagementContext.swift
//  SuperVarioWohnenServerPackageDescription
//
//  Created by Max Bause on 04.01.18.
//

import Foundation
import Kitura
import SwiftyJSON
import MySQL

class ManagementContext {
    
    private let connection: ConnectionPool
    
    init(connection: ConnectionPool) {
        self.connection = connection
    }

func getManagement(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) -> Void {
    if let auth = request.headers["auth"], let tenant = Tenant.getTentantByCode(code: auth, connection: connection) {
        do {
            let params = build((tenant.objectId))
            let management: [Management] = try connection.execute { try $0.query("SELECT m.* FROM Tenant t JOIN Object o ON t.object_id = o.id JOIN Management m ON o.management_id = m.id WHERE t.id = ?;", params) }
            response.status(.OK).send(json: JSON(management.map {$0.toJson(connection: connection)}))
            next()
        } catch {
            print(error)
        }
        response.status(.internalServerError)
        next()
    } else {
        response.status(.unauthorized)
        next()
    }
  }
}
