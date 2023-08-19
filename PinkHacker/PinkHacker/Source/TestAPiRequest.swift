//
//  TestAPiRequest.swift
//  PinkHacker
//
//  Created by 김가영 on 2023/08/19.
//

import Foundation

final class TestAPIRequest: APIRequest<TestResponse> {
    init() {
        super.init(path: "/test")
    }
}

struct TestResponse: Codable {
    let name: String
    let age: String
}
