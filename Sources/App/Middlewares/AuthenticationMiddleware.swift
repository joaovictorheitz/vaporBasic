//
//  File.swift
//  
//
//  Created by João Victor de Souza Guedes on 19/08/24.
//

import Foundation
import Vapor

struct AuthenticationMiddleware: AsyncMiddleware {
    func respond(to request: Vapor.Request, chainingTo next: any Vapor.AsyncResponder) async throws -> Vapor.Response {
        guard let _ = request.headers.bearerAuthorization else {
            throw Abort(.unauthorized)
        }
        
        return try await next.respond(to: request)
    }
}
