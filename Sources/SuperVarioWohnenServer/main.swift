import Kitura
import Foundation

let router = Router()

router.get("/") {
    request, response, next in
    response.send("Hello World")
    next()
}

let tenantContext = TenantContext()
router.all(middleware: BodyParser())

router.get("/mieter", handler: tenantContext.getTenant)
router.post("/mieter", handler: tenantContext.postTenant)

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
