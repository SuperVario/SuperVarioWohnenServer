//
//  BoardEntryContext.swift
//  SuperVarioWohnenServerPackageDescription
//
//  Created by Tobias on 30.11.17.
//

import Foundation
import Kitura
import MySQL
import SwiftyJSON

class BoardEntryContext {
    
    private let connection: ConnectionPool
    
    init(connection: ConnectionPool) {
        self.connection = connection
    }
    
    func getAllEntries(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) -> Void {
        
        
        if let session = request.headers["session"], let staff = Staff.getStaffBySession(session: session, connection: connection) {
            do {
                let params = build((staff.managementId))
                let entries: [BoardEntry] = try connection.execute { try $0.query("SELECT * FROM BoardEntry b WHERE b.object_id in (SELECT o.id FROM Object o WHERE o.management_id = ?);", params) }
                response.status(.OK).send(json: JSON(entries.map {$0.toJson()}))
                next()
            } catch {
                print(error)
            }
            response.status(.internalServerError)
            next()
        }
        
        if let auth = request.headers["auth"], let tenant = Tenant.getTentantByCode(code: auth, connection: connection) {
            do {
                let params = build((tenant.objectId))
                let entries: [BoardEntry] = try connection.execute { try $0.query("SELECT * FROM BoardEntry WHERE object_id = ?;", params) }
                response.status(.OK).send(json: JSON(entries.map {$0.toJson()}))
                next()
            } catch {
                print(error)
            }
            response.status(.internalServerError)
            next()
        }
        response.status(.unauthorized)
        next()
    }
    
    func postBoardEntry(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) -> Void {
        if let session = request.headers["session"], let _ = Staff.getStaffBySession(session: session, connection: connection) {
            if let json = request.body?.asJSON {
                var boardEntry = BoardEntry.fromJson(json: json)
                do {
                    let status = try connection.execute { try $0.query("INSERT INTO BoardEntry SET ?;", [boardEntry]) }
                    boardEntry.id = Int(status.insertedID)
                    
                    response.status(.created).send(json: boardEntry.toJson())
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
    
    func putBoardEntry(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) -> Void {
        if let session = request.headers["session"], let _ = Staff.getStaffBySession(session: session, connection: connection) {
            if let json = request.body?.asJSON, let id = Int(request.parameters["id"] ?? ""){
                var boardEntry = BoardEntry.fromJson(json: json)
                boardEntry.id = id
                do {
                    let params = build((boardEntry.title, boardEntry.message, boardEntry.createDate.description, boardEntry.expireDate?.description ?? nil, boardEntry.id))
                    _ = try connection.execute { try $0.query("UPDATE BoardEntry SET title = ?, message = ?, create_date = ?, expire_date = ? WHERE id = ?;", params) }
    
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
    
    func deleteBoardEntry(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) -> Void {
        if let session = request.headers["session"], let _ = Staff.getStaffBySession(session: session, connection: connection) {
            if let id = Int(request.parameters["id"] ?? "") {
                do {
                    let params = build((id))
                    _ = try connection.execute { try $0.query("DELETE FROM BoardEntry WHERE id = ?;", params) }
                    
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
