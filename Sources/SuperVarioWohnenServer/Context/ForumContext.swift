//
//  ForumContext.swift
//  SuperVarioWohnenServerPackageDescription
//
//  Created by Tobias on 07.12.17.
//

import Foundation
import Kitura
import MySQL
import SwiftyJSON

class ForumContext {
    
    private let connection: ConnectionPool
    
    init(connection: ConnectionPool) {
        self.connection = connection
    }
    
    func getForumCategories(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) -> Void {
        if let auth = request.headers["auth"], let tenant = Tenant.getTentantByCode(code: auth, connection: connection) {
            do {
                let params = build((tenant.objectId))
                let entries: [ForumCategory] = try connection.execute { try $0.query("SELECT * FROM ForumCategory WHERE object_id = ?;", params) }
                response.status(.OK).send(json: JSON(entries.map {$0.toJson()}))
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
    
    func getForumEntries(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) -> Void {
        func getEntries() {
            if let category = Int(request.parameters["category"] ?? "") {
                do {
                    let params = build((category))
                    let entries: [ForumEntry] = try connection.execute { try $0.query("SELECT * FROM ForumEntry WHERE category_id = ?;", params) }
                    response.status(.OK).send(json: JSON(entries.map {$0.toJson(connection: connection)}))
                    next()
                } catch {
                    print(error)
                }
                response.status(.internalServerError)
                next()
            }
            response.status(.badRequest)
            next()
        }
        if let auth = request.headers["auth"], let _ = Tenant.getTentantByCode(code: auth, connection: connection) {
            getEntries()
        } else if let session = request.headers["session"], let _ = Staff.getStaffBySession(session: session, connection: connection) {
            getEntries()
        } else {
            response.status(.unauthorized)
            next()
        }
    }
    
    func postEntry(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) -> Void {
        if let auth = request.headers["auth"], let tenant = Tenant.getTentantByCode(code: auth, connection: connection) {
            if let category = Int(request.parameters["category"] ?? "") {
                if let json = request.body?.asJSON {
                    var entry = ForumEntry.fromJson(json: json)
                    entry.categoryId = category
                    entry.tenantId = tenant.id
                    do {
                        let status = try connection.execute { try $0.query("INSERT INTO ForumEntry SET ?;", [entry]) }
                        entry.id = Int(status.insertedID)
                        
                        response.status(.OK).send(json: entry.toJson(connection: connection))
                        next()
                    } catch QueryError.queryExecutionError(let message, _) {
                        print("SQL Error: \(message)")
                        response.status(.badRequest).send(message)
                        next()
                    } catch {
                        print(error)
                    }
                }
            }
            response.status(.badRequest)
            next()
        } else {
            response.status(.unauthorized)
            next()
        }
    }
    
    func getForumAnswers(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) -> Void {
        func getAnswer() {
            if let _ = Int(request.parameters["category"] ?? ""), let entry = Int(request.parameters["entry"] ?? "") {
                do {
                    let params = build((entry))
                    let entries: [ForumAnswer] = try connection.execute { try $0.query("SELECT * FROM ForumAnswer WHERE entry_id = ?;", params) }
                    response.status(.OK).send(json: JSON(entries.map {$0.toJson(connection: connection)}))
                    next()
                } catch {
                    print(error)
                }
                response.status(.internalServerError)
                next()
            }
            response.status(.badRequest)
            next()
        }
        if let auth = request.headers["auth"], let _ = Tenant.getTentantByCode(code: auth, connection: connection) {
            getAnswer()
        } else if let session = request.headers["session"], let _ = Staff.getStaffBySession(session: session, connection: connection) {
            getAnswer()
        } else {
            response.status(.unauthorized)
            next()
        }
    }
    
    func postAnswer(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) -> Void {
        if let auth = request.headers["auth"], let tenant = Tenant.getTentantByCode(code: auth, connection: connection) {
            if let entry = Int(request.parameters["entry"] ?? "") {
                if let json = request.body?.asJSON {
                    var answer = ForumAnswer.fromJson(json: json)
                    answer.entryId = entry
                    answer.tenantId = tenant.id
                    do {
                        let status = try connection.execute { try $0.query("INSERT INTO ForumAnswer SET ?;", [answer]) }
                        answer.id = Int(status.insertedID)
                        
                        response.status(.OK).send(json: answer.toJson(connection: connection))
                        next()
                    } catch QueryError.queryExecutionError(let message, _) {
                        print("SQL Error: \(message)")
                        response.status(.badRequest).send(message)
                        next()
                    } catch {
                        print(error)
                    }
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
