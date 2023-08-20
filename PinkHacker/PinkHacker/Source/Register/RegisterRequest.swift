//
//  RegisterRequest.swift
//  PinkHacker
//
//  Created by Woody Lee on 2023/08/20.
//

import Foundation

final class RegisterRequest: APIRequest<EmptyDTOReponse> {
    init() {
        super.init(path: "/api/recipes")
    }
}

struct RegisterRequestDatat: Encodable {
    var recipeId: Int
    var imgUrl: String?
    var description: String
}

struct EmptyDTOReponse: Codable {}
