import Kitura
import Foundation
import MySQL
import SwiftyJSON

let fileManager = FileManager.default
let path = fileManager.currentDirectoryPath.appending("/settings.json")
if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
    class SqlSettings: ConnectionOption {
        init(data: Data) {
            let settingsJson = JSON(data: data)

            host = settingsJson["host"].stringValue
            port = settingsJson["port"].intValue
            user = settingsJson["user"].stringValue
            password = settingsJson["password"].stringValue
            database = settingsJson["database"].stringValue
        }
        
        let host: String
        let port: Int
        let user: String
        let password: String
        let database: String
    }
    
    let pool = ConnectionPool(options: SqlSettings(data: data))
    
    let router = Router()
    
    router.get("/") {
        request, response, next in
        response.send("Hello World")
        next()
    }
    
    let loginContext = LoginContext(connection: pool)
    let tenantContext = TenantContext(connection: pool)
    let documentContext = DocumentContext(connection: pool)
    let boardEntryContext = BoardEntryContext(connection: pool)
    
    router.all(middleware: BodyParser())
    
    router.post("/login", handler: loginContext.login)
    
    router.get("/mieter", handler: tenantContext.getTenant)
    router.post("/mieter", handler: tenantContext.postTenant)
    
    router.get("/documents", handler: documentContext.getAllDocuments)
    router.get("/documents/:id", handler: documentContext.getDocument)
    router.post("/documents", handler: documentContext.postDocument)
    
    router.get("/board", handler: boardEntryContext.getAllEntries)
    
    router.all("/app", middleware: StaticFileServer())
    
    #if os(OSX)
        Kitura.addHTTPServer(onPort: 2530, with: router)
    #else
        let path = CommandLine.arguments[1]
        let certFile = "\(path)/cert.pem"
        let keyFile = "\(path)/privkey.pem"
        let sslConfig = SSLConfig(withCACertificateDirectory: nil,
                                  usingCertificateFile: certFile,
                                  withKeyFile: keyFile,
                                  usingSelfSignedCerts: true)
        Kitura.addHTTPServer(onPort: 2530, with: router, withSSL: sslConfig, keepAlive: .unlimited)
    #endif
    
    Kitura.run()
} else {
    print("Settings missing at path: \(path)")
}
