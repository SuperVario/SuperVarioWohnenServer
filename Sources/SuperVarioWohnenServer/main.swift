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
    let managementContext = ManagementContext(connection: pool)
    
    router.all(middleware: BodyParser())
    
    router.post("/login", handler: loginContext.login)
    router.get("/validation", handler: loginContext.validateCode)
    
    router.get("/object", handler: objectHandler.getObjects)
    router.post("/object", handler: objectHandler.postObject)
    
    router.get("/tenant", handler: tenantContext.getTenants)
    router.get("/tenant/:id", handler: tenantContext.getTenant)
    router.post("/tenant", handler: tenantContext.postTenant)
    router.put("/tenant/:id", handler: tenantContext.putTenant)
    router.delete("/tenant/:id", handler: tenantContext.deleteTenant)
    
    router.get("/documents", handler: documentContext.getAllDocuments)
    router.get("/documents/:id", handler: documentContext.getDocument)
    router.post("/documents", handler: documentContext.postDocument)
    router.delete("/documents", handler: documentContext.deleteDocument)
    
    router.get("/board", handler: boardEntryContext.getAllEntries)
    router.post("/board", handler: boardEntryContext.postBoardEntry)
    router.put("/board/:id", handler: boardEntryContext.putBoardEntry)
    router.delete("/board/:id", handler: boardEntryContext.deleteBoardEntry)
    
    router.post("/upload", handler: uploadContext.uploadFile)
    
    router.get("/forum", handler: forumContext.getForumCategories)
    router.get("/forum/:category", handler: forumContext.getForumEntries)
    router.post("/forum/:category", handler: forumContext.postEntry)
    router.get("/forum/:category/:entry", handler: forumContext.getForumAnswers)
    router.post("/forum/:category/:entry", handler: forumContext.postAnswer)
    
    router.get("/management", handler: managementContext.getManagement)
    
    router.all("/app", middleware: StaticFileServer())
    
    class AfterHandler: RouterMiddleware {
        func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) {
            response.headers["Access-Control-Allow-Origin"] = "*"
            next()
        }
    }
    
    router.all(middleware: AfterHandler())
    
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
