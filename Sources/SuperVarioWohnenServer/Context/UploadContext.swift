//
//  UploadContext.swift
//  SuperVarioWohnenServerPackageDescription
//
//  Created by Tobias on 07.12.17.
//

import Foundation
import MySQL
import Kitura

class UploadContext {
    
    private let uploadPath: String
    
    init(uploadPath: String) {
        self.uploadPath = uploadPath
    }
    
    func uploadFile(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) -> Void {
        if let body = request.body?.asMultiPart {
            for part in body {
                if case let .raw(data) = part.body {
                    let uuid = UUID()
                    let url = URL(fileURLWithPath: "\(uploadPath)/\(uuid.uuidString)")
                    do {
                      try data.write(to: url)
                    } catch {
                        print(error)
                    }
                    response.send(uuid.uuidString)
                    next()
                }
            }
        }
    }
}
