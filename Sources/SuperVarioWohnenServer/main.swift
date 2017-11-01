import Kitura

let router = Router()

router.get("/") {
    request, response, next in
    response.send("Hello World")
    next()
}

#if os(Linux)
    let path = CommandLine.arguments[0]
    let certFile = "\(path)/cert.pem"
    let keyFile = "\(path)/privkey.pem"
    let sslConfig = SSLConfig(withCACertificateDirectory: nil,
                          usingCertificateFile: certFile,
                          withKeyFile: keyFile,
                          usingSelfSignedCerts: true)
    Kitura.addHTTPServer(onPort: 2530, with: router, withSSL: sslConfig, keepAlive: .unlimited)
#else
    Kitura.addHTTPServer(onPort: 2530, with: router)
#endif

Kitura.run()
