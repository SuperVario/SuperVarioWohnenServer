//
//  LoginContext.swift
//  SuperVarioWohnenServerPackageDescription
//
//  Created by Tobias on 01.12.17.
//

import Foundation
import Kitura
import SwiftyJSON
import MySQL

class LoginContext {
    
    private let connection :ConnectionPool
    
    init(connection: ConnectionPool) {
        self.connection = connection
    }
    
    func login(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) -> Void {
        if let json = request.body?.asJSON {
            if let username = json["username"].string, let pwd = json["psw"].string {
                do {
                    let params = build((username, pwd))
                    let staffs: [Staff] = try connection.execute { try $0.query("SELECT * FROM Staff WHERE username = ? AND password = ?;", params) }
                    if var first = staffs.first {
                        if let session = first.session {
                            response.status(.OK).send(session)
                            next()
                        } else {
                            let newSession = String.randomString(length: 100)
                            first.session = newSession
                            _ = try connection.execute { try $0.query("UPDATE Staff SET session = ? WHERE id = ?;", build((first.session, first.id))) }
                            response.status(.OK).send(newSession)
                            next()
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
        response.status(.unauthorized)
        next()
    }
    
}
