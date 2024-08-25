//
//  File.swift
//  
//
//  Created by João Victor de Souza Guedes on 17/08/24.
//

import Vapor
import Fluent
import FluentMySQLDriver

final class User: Model, Content {
    static let schema = "users"

    @ID(custom: .id, generatedBy: .user)
    var id: Int?

    @Field(key: "name")
    var name: String

    init() { }

    init(id: Int? = nil, name: String) {
        self.id = id
        self.name = name
    }
}
