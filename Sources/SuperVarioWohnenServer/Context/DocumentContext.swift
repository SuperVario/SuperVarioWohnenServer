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
    
    let connection: ConnectionPool
    
    init(connection: ConnectionPool) {
        self.connection = connection
    }
    
    func getAllDocuments(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) -> Void {
        if let auth = request.headers["auth"] {
            if let tenantOptional = try? Tenant.getTentantByCode(code: auth, connection: connection), let tenant = tenantOptional {
                do {
                    let params = build((tenant.id))
                    let documents: [Document] = try connection.execute { try $0.query("SELECT * FROM Document WHERE tenant_id = ?;", params) }
                    response.status(.OK).send(json: JSON(documents.map {$0.toJson()}))
                    next()
                } catch {
                    print(error)
                }
                
                response.status(.notFound)
                next()
            }
        }
        response.status(.unauthorized)
        next()
    }
    
    func getDocument(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) -> Void {
        if let auth = request.headers["auth"] {
            if let tenantOptional = try? Tenant.getTentantByCode(code: auth, connection: connection), let tenant = tenantOptional {
                guard let documentString = request.parameters["id"], let documentId = Int(documentString) else {
                    response.status(.badRequest)
                    next()
                    return
                }
                
                do {
                    let params = build((tenant.id, documentId))
                    let documents: [Document] = try connection.execute { try $0.query("SELECT * FROM Document WHERE tenant_id = ? AND id = ?;", params) }
                    guard let first = documents.first else {
                        response.status(.notFound)
                        next()
                        return
                    }
                    
                    let acceptType = request.headers["Accept-Type"]
                    if let acceptType = acceptType, acceptType == "application/pdf" {
                        let fileManager = FileManager.default
                        let path = fileManager.currentDirectoryPath.appending(first.filename)
                        if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                            response.status(.OK).send(data: data)
                        } else {
                            response.status(.internalServerError)
                        }
                    } else {
                        response.status(.OK).send(json: first.toJson())
                    }
                    next()
                    return
                } catch {
                    print(error)
                }
                
                response.status(.notFound)
                next()
            }
        }
        response.status(.unauthorized)
        next()
    }
    
    func postDocument(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) -> Void {
        // TODO Management Auth
        if let body = request.body?.asMultiPart {
            for part in body {
                print(part)
            }
        }
        response.status(.OK)
        next()
    }
}
