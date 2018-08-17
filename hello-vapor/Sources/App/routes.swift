import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    struct Status : Content {
        var message: String
    }
    
    func handleStatusPost(_ req: Request) throws -> String {
        let status = try req.content.syncDecode(Status.self)
        return status.message
    }
    
    router.get { req -> String in
        return "This is the root path"
    }
    
    router.get("home") { req -> String in
        return "this is the home page"
    }
    
    router.get("status") { req -> Status in
        return Status(message: "This is a custom JSON response.")
    }
    
    router.post("status", use: handleStatusPost)
    
    // users/ben   users/mary
    router.get("users", String.parameter) { req -> String in
        let username = try req.parameters.next(String.self)
        return "Hello, \(username)"
    }
    
    // admin/home   admin/new
    router.group("admin") { admin in
        admin.get("home") { req in return "home" }
        admin.get("new") { req in return "new" }
    }
    
    router.get("boom") { req -> String in
        throw Abort(HTTPResponseStatus.internalServerError)
        
    }
}
