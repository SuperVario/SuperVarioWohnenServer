//
//  DocumentContext.swift
//  SuperVarioWohnenServer
//
//  Created by Tobias on 30.11.17.
//

import Foundation
import Kitura
import SwiftyJSON
import MySQL

class DocumentContext {
    
    private let connection: ConnectionPool
    private let uploadPath: String
    
    init(connection: ConnectionPool, uploadPath: String) {
        self.connection = connection
        self.uploadPath = uploadPath
    }
    
    func getAllDocuments(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) -> Void {
        if let auth = request.headers["auth"], let tenant = Tenant.getTentantByCode(code: auth, connection: connection) {
            do {
                let params = build((tenant.id))
                let documents: [Document] = try connection.execute { try $0.query("SELECT * FROM Document WHERE tenant_id = ?;", params) }
                response.status(.OK).send(json: JSON(documents.map {$0.toJson()}))
                next()
            } catch {
                print(error)
            }
        } else {
            response.status(.unauthorized)
            next()
        }
    }
    
    func getDocument(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) -> Void {
        guard let documentString = request.parameters["id"], let documentId = Int(documentString) else {
            response.status(.badRequest)
            next()
            return
        }
        
        do {
            let document: Document?
            if let auth = request.headers["auth"], let tenant = Tenant.getTentantByCode(code: auth, connection: connection) {
                let params = build((tenant.id, documentId))
                let documents: [Document] = try connection.execute { try $0.query("SELECT * FROM Document WHERE tenant_id = ? AND id = ?;", params) }
                guard let first = documents.first else {
                    response.status(.notFound)
                    next()
                    return
                }
                document = first
            } else if let session = request.headers["session"], let staff = Staff.getStaffBySession(session: session, connection: connection) {
                let params = build((documentId, staff.session))
                let documents: [Document] = try connection.execute { try $0.query("SELECT d.* FROM Document d JOIN Tenant t ON d.tenant_id = t.id JOIN Object o ON o.id = t.object_id JOIN Management m ON m.id = o.management_id JOIN Staff s ON s.management_id = m.id WHERE d.id = ? AND s.session = ?;", params) }
                guard let first = documents.first else {
                    response.status(.notFound)
                    next()
                    return
                }
                document = first
            } else {
                response.status(.unauthorized)
                next()
                document = nil
            }
            
            if let document = document {
                let acceptType = request.headers["Accept-Type"]
                if let acceptType = acceptType, acceptType == "application/pdf" {
                    let url = URL(fileURLWithPath: "\(uploadPath)/\(document.documentId)")
                    if let data = try? Data(contentsOf: url) {
                        response.status(.OK).send(data: data)
                    } else {
                        response.status(.internalServerError)
                    }
                } else {
                    response.status(.OK).send(json: document.toJson())
                }
            }
            next()
        } catch {
            print(error)
        }
        response.status(.internalServerError)
        next()
    }
    
    func postDocument(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) -> Void {
        if let session = request.headers["session"], let _ = Staff.getStaffBySession(session: session, connection: connection) {
            if let json = request.body?.asJSON {
                guard let tenantId = json["tenantId"].int,
                        let documentId = json["documentId"].string,
                        let documentName = json["name"].string,
                        let folder = json["folder"].string else {
                    response.status(.badRequest)
                    next()
                    return
                }
            
                var document = Document(id: -1, documentId: documentId, tenantId: tenantId, name: documentName, folder: folder)
                
                do {
                    let status = try connection.execute { try $0.query("INSERT INTO Document SET ?;", [document]) }
                    document.id = Int(status.insertedID)
                    
                    // Insert into database
                    response.status(.OK).send(json: document.toJson())
                    next()
                } catch QueryError.queryExecutionError(let message, _) {
                    print("SQL Error: \(message)")
                    response.status(.badRequest).send(message)
                    next()
                    return
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
    
    func deleteDocument(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) -> Void {
        if let session = request.headers["session"], let _ = Staff.getStaffBySession(session: session, connection: connection) {
            if let id = Int(request.parameters["id"] ?? "") {
                do {
                    let params = build((id))
                    _ = try connection.execute { try $0.query("DELETE FROM Document WHERE id = ?;", params) }
                    
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
