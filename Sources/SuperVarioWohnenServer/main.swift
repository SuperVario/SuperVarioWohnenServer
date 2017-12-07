import Kitura
import Foundation
import MySQL
import SwiftyJSON

let fileManager = FileManager.default
let path = fileManager.currentDirectoryPath.appending("/settings.json")
if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
    class Settings: ConnectionOption {
        init(data: Data) {
            let settingsJson = JSON(data: data)

            host = settingsJson["host"].stringValue
            port = settingsJson["port"].intValue
            user = settingsJson["user"].stringValue
            password = settingsJson["password"].stringValue
            database = settingsJson["database"].stringValue
            uploadPath = settingsJson["uploadPath"].stringValue
        }
        
        let host: String
        let port: Int
        let user: String
        let password: String
        let database: String
        let uploadPath: String
    }
    
    let settings = Settings(data: data)
    let pool = ConnectionPool(options: settings)
    
    let router = Router()
    
    router.get("/") {
        request, response, next in
        response.send("Hello World")
        next()
    }
    
    let loginContext = LoginContext(connection: pool)
    let objectHandler = ObjectHandler(connection: pool)
    let tenantContext = TenantContext(connection: pool)
    let documentContext = DocumentContext(connection: pool, uploadPath: settings.uploadPath)
    let boardEntryContext = BoardEntryContext(connection: pool)
    let uploadContext = UploadContext(uploadPath: settings.uploadPath)
    let forumContext = ForumContext(connection: pool)
    
    router.all(middleware: BodyParser())
    
    router.post("/login", handler: loginContext.login)
    
    router.get("/object", handler: objectHandler.getObjects)
    router.post("/object", handler: objectHandler.postObject)
    
    router.get("/tenant", handler: tenantContext.getTenant)
    router.post("/tenant", handler: tenantContext.postTenant)
    router.put("/tenant", handler: tenantContext.postTenant)
    
    router.get("/documents", handler: documentContext.getAllDocuments)
    router.get("/documents/:id", handler: documentContext.getDocument)
    router.post("/documents", handler: documentContext.postDocument)
    
    router.get("/board", handler: boardEntryContext.getAllEntries)
    router.post("/board", handler: boardEntryContext.postBoardEntry)
    
    router.post("/upload", handler: uploadContext.uploadFile)
    
    router.get("/forum", handler: forumContext.getForumCategories)
    router.get("/forum/:category", handler: forumContext.getForumEntries)
    router.post("/forum/:category", handler: forumContext.postEntry)
    router.get("/forum/:category/:entry", handler: forumContext.getForumAnswers)
    router.post("/forum/:category/:entry", handler: forumContext.postAnswer)

    router.all("/app", middleware: StaticFileServer())
    
    #if os(OSX)
        Kitura.addHTTPServer(onPort: 2530, with: router)
    #else
        srandom(UInt32(time(nil)))
        
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
