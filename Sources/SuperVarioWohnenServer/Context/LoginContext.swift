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
                    if let first = staffs.first {
                        // TODO Generate cookie
                        response.status(.OK).send("\(first.id)")
                        next()
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
