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
        do {
            let entries: [BoardEntry] = try connection.execute { try $0.query("SELECT * FROM BoardEntry;") }
            response.status(.OK).send(json: JSON(entries.map {$0.toJson()}))
            next()
        } catch {
            print(error)
        }
        response.status(.internalServerError)
        next()
    }
}
