//
//  File.swift
//  
//
//  Created by João Victor de Souza Guedes on 18/08/24.
//

import Foundation
import Vapor
import FluentKit

struct UsersController: RouteCollection {
    func boot(routes: any Vapor.RoutesBuilder) throws {
        let users = routes.grouped("users")
        let privateEndPoints = users.grouped(AuthenticationMiddleware())

        privateEndPoints.post("addUser", use: saveUser)
        privateEndPoints.delete("deleteUser", use: deleteUser)
        privateEndPoints.post("updateUserName", ":id", use: updateUserName)
        
        users.get(use: getAllUsers)
    }
    
    @Sendable
    func getAllUsers(req: Request) async throws -> [User] {        
        if let id = getUserIdParameter(req: req) {
            return [try await getUserId(id: id, db: req.db)]
        }

        return try await User.query(on: req.db).all()
    }

    func getUserId(id: Int?, db: Database) async throws -> User {
        guard let user = try await User.find(id, on: db) else {
            throw Abort(.notFound)
        }

        return user
    }
    
    @Sendable
    func saveUser(req: Request) async throws -> User {
        let user = try req.content.decode(User.self)
        try await user.save(on: req.db)
        
        return user
    }
    
    @Sendable
    func deleteUser(req: Request) async throws -> String {
        guard let id = getUserIdParameter(req: req) else { throw Abort(.badRequest) }

        try await getUserId(id: id, db: req.db).delete(on: req.db) 

        return "User deleted"
    }

    @Sendable
    func updateUserName(req: Request) async throws -> String {
        let id = req.parameters.get("id", as: Int.self)
        let user = try await getUserId(id: id, db: req.db)
        let name = try req.query.get(String.self, at: "name")

        user.name = name

        try await user.update(on: req.db)

        return "User updated"
    }

    func getUserIdParameter(req: Request) -> Int? {
        guard let id = try? req.query.get(Int.self, at: "id") else { return nil }

        return id
    }
}
