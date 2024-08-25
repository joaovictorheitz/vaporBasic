//
//  File.swift
//  
//
//  Created by João Victor de Souza Guedes on 18/08/24.
//

import Foundation
import Vapor

struct HelloController: RouteCollection {
    func boot(routes: any Vapor.RoutesBuilder) throws {
        let hello = routes.grouped("hello")
        
        hello.get(use: getHello)
    }
    
    @Sendable
    func getHello(req: Request) throws -> String {
        guard let name = try? req.query.get(String.self, at: "name") else {
            return "Hello world!"
        }

        return "Hello \(name.capitalized)!"
    }
}
