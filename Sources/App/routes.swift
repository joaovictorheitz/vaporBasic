import Vapor
import MySQLKit
import Fluent

func routes(_ app: Application) throws {
    try app.register(collection: UsersController())
    try app.register(collection: HelloController())
    
    app.get { req async in
        "It works!"
    }
}
