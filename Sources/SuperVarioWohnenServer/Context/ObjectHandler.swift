//
//  ObjectHandler.swift
//  SuperVarioWohnenServerPackageDescription
//
//  Created by Tobias on 07.12.17.
//

import Foundation
import Kitura
import SwiftyJSON
import MySQL

class ObjectHandler {
    
    private let connection: ConnectionPool
    
    init(connection: ConnectionPool) {
        self.connection = connection
    }
    
    func getObjects(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) -> Void {
        if let session = request.headers["session"], let staff = Staff.getStaffBySession(session: session, connection: connection) {
            do {
                let params = build((staff.managementId))
                let entries: [HouseObject] = try connection.execute { try $0.query("SELECT * FROM Object o WHERE o.management_id = ?;", params) }
                response.status(.OK).send(json: JSON(entries.map {$0.toJson()}))
                next()
            } catch {
                print(error)
            }
            response.status(.internalServerError)
            next()
        }
    }
    
    func postObject(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) -> Void {
        if let session = request.headers["session"], let staff = Staff.getStaffBySession(session: session, connection: connection) {
            if let json = request.body?.asJSON {
                var houseObject = HouseObject.fromJson(json: json)
                houseObject.managementId = staff.managementId
                do {
                    let status = try connection.execute { try $0.query("INSERT INTO Object SET ?;", [houseObject]) }
                    houseObject.id = Int(status.insertedID)
                    
                    response.status(.created).send(json: houseObject.toJson())
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
}
