//
//  Tenant.swift
//  SuperVarioWohnenServer
//
//  Created by Tobias on 17.11.17.
//

import Foundation
import Kitura
import SwiftyJSON
import MySQL

class TenantContext {
    
    private let connection: ConnectionPool
    
    init(connection: ConnectionPool) {
        self.connection = connection
    }
    
    func getTenant(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) -> Void {
        if let tenantString = request.queryParameters["tenantId"], let tenantId = Int(tenantString) {
            do {
                let params = build((tenantId))
                let tenants: [Tenant] = try connection.execute { try $0.query("SELECT * FROM Tenant WHERE id = ?;", params) }
                if let first = tenants.first {
                    response.status(.OK).send(json: first.toJson())
                    next()
                }
            } catch {
                print(error)
            }
        } else if let objectString = request.queryParameters["objectId"], let objectId = Int(objectString) {
            do {
                let params = build((objectId))
                let tenants: [Tenant] = try connection.execute { try $0.query("SELECT * FROM Tenant WHERE object_id = ?;", params) }
                response.status(.OK).send(json: JSON(tenants.map {$0.toJson()}))

            } catch {
                print(error)
            }
        } else {
            do {
                let tenants: [Tenant] = try connection.execute { try $0.query("SELECT * FROM Tenant;") }
                response.status(.OK).send(json: JSON(tenants.map {$0.toJson()}))
                next()
            } catch {
                print(error)
            }
        }
        response.status(.internalServerError)
        next()
    }
    
    func postTenant(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) -> Void {
        if let json = request.body?.asJSON {
            var tenant = Tenant.fromJson(json: json)
            do {
                let status = try connection.execute { try $0.query("INSERT INTO Tenant SET ?;", [tenant]) }
                tenant.id = Int(status.insertedID)
            
                // Insert into database
                response.status(.OK).send(json: tenant.toJson())
                next()
            } catch QueryError.queryExecutionError(let message, _) {
                print("SQL Error: \(message)")
                response.status(.badRequest).send(message)
                next()
            } catch {
                print(error)
            }
        }
        response.status(.badRequest)
        next()
    }
}
