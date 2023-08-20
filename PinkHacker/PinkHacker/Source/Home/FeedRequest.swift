//
//  File.swift
//  PinkHacker
//
//  Created by Woody Lee on 2023/08/20.
//

import Foundation

final class FeedRequest: APIRequest<[FeedResponse]> {
    enum Sort: String {
        case popular
        case createdDate
    }
    init(sort: Sort) {
        super.init(path: "/api/recipes/feed?sort=\(sort.rawValue)")
    }
}

struct FeedResponse: Codable {
    var id: Int
    var description: String
    var category: String
    var productId: Int
    var orderCount: Int
    var imgUrl: String?
}
