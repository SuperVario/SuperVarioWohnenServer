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
    
    func getTenants(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) -> Void {
        if let session = request.headers["session"], let staff = Staff.getStaffBySession(session: session, connection: connection) {
            if let tenantString = request.queryParameters["tenantId"], let tenantId = Int(tenantString) {
                do {
                    let params = build((staff.session, tenantId))
                    let tenants: [Tenant] = try connection.execute { try $0.query("SELECT t.* FROM Tenant t JOIN Object o ON o.id = t.object_id JOIN Management m ON m.id = o.management_id JOIN Staff s ON s.management_id = m.id WHERE s.session = ? AND t.id = ? AND t.active = 1;", params) }
                    if let first = tenants.first {
                        response.status(.OK).send(json: first.toJson(connection: connection))
                        next()
                    }
                } catch {
                    print(error)
                }
            } else if let objectString = request.queryParameters["objectId"], let objectId = Int(objectString) {
                do {
                    let params = build((staff.session, objectId))
                    let tenants: [Tenant] = try connection.execute { try $0.query("SELECT t.* FROM Tenant t JOIN Object o ON o.id = t.object_id JOIN Management m ON m.id = o.management_id JOIN Staff s ON s.management_id = m.id WHERE s.session = ? AND o.id = ? AND t.active = 1;", params) }
                    response.status(.OK).send(json: JSON(tenants.map {$0.toJson(connection: connection)}))
                    next()
                } catch {
                    print(error)
                }
            } else {
                do {
                    let params = build((staff.session))
                    let tenants: [Tenant] = try connection.execute { try $0.query("SELECT t.* FROM Tenant t JOIN Object o ON o.id = t.object_id JOIN Management m ON m.id = o.management_id JOIN Staff s ON s.management_id = m.id WHERE s.session = ? AND t.active = 1;", params) }
                    response.status(.OK).send(json: JSON(tenants.map {$0.toJson(connection: connection)}))
                    next()
                } catch {
                    print(error)
                }
            }
            response.status(.internalServerError)
            next()
        } else {
            response.status(.unauthorized)
            next()
        }
    }

    func getTenant(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) -> Void {
        if let session = request.headers["session"], let staff = Staff.getStaffBySession(session: session, connection: connection) {
            if let tenantString = request.parameters["id"], let tenantId = Int(tenantString) {
                do {
                    let params = build((staff.session, tenantId))
                    let tenants: [Tenant] = try connection.execute { try $0.query("SELECT t.* FROM Tenant t JOIN Object o ON o.id = t.object_id JOIN Management m ON m.id = o.management_id JOIN Staff s ON s.management_id = m.id WHERE s.session = ? AND t.id = ? AND t.active = 1;", params) }
                    if let first = tenants.first {
                        response.status(.OK).send(json: first.toJson(connection: connection))
                        next()
                        return
                    }
                } catch {
                    print(error)
                }
            }
            response.status(.notFound)
            next()
        } else {
            response.status(.unauthorized)
            next()
        }
    }
    
    func postTenant(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) -> Void {
        if let session = request.headers["session"], let _ = Staff.getStaffBySession(session: session, connection: connection) {
            if let json = request.body?.asJSON {
                var tenant = Tenant.fromJson(json: json)
                tenant.active = true
                do {
                    let status = try connection.execute { try $0.query("INSERT INTO Tenant SET ?;", [tenant]) }
                    tenant.id = Int(status.insertedID)
                
                    response.status(.created).send(json: tenant.toJson(connection: connection))
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
        } else {
            response.status(.unauthorized)
            next()
        }
    }
    
    
    func putTenant(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) -> Void {
        if let session = request.headers["session"], let _ = Staff.getStaffBySession(session: session, connection: connection) {
            if let json = request.body?.asJSON {
                var tenant = Tenant.fromJson(json: json)
                tenant.active = true
                do {
                    let param = build((tenant.name, tenant.lastName, tenant.telefon, tenant.mail, tenant.id))
                    _ = try connection.execute { try $0.query("UPDATE Tenant SET name = ?, last_name = ?, telefon = ?, mail = ? WHERE id = ?;", param) }
                    
                    response.status(.OK).send(json: tenant.toJson(connection: connection))
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
        } else {
            response.status(.unauthorized)
            next()
        }
    }
    
    func deleteTenant(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) -> Void {
        if let session = request.headers["session"], let _ = Staff.getStaffBySession(session: session, connection: connection) {
            if let id = Int(request.parameters["id"] ?? "") {
                do {
                    let params = build((id))
                    _ = try connection.execute { try $0.query("UPDATE Tenant SET active = 0 WHERE id = ?;", params) }
                    
                    response.status(.OK)
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
        } else {
            response.status(.unauthorized)
            next()
        }
    }
}
