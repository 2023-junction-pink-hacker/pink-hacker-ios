//
//  PostOrderRequest.swift
//  PinkHacker
//
//  Created by 김가영 on 2023/08/20.
//

import Foundation

import Foundation

final class PostOrderRequest: APIRequest<SimpleResponse> {
    init() {
        super.init(path: "/api/recipes")
    }
}

final class SimpleResponse: Codable {
    
}
