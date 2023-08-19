//
//  OrderRequest.swift
//  PinkHacker
//
//  Created by 김가영 on 2023/08/20.
//

import Foundation

final class OrderRequest: APIRequest<OrderResponse> {
    init(productId: Int) {
        super.init(path: "/api/steps/products/\(productId)")
    }
}

struct OrderResponse: Codable {
    let productId: Int?
    let steps: [OrderStepDataModel]?
}

struct OrderStepDataModel: Codable {
    let id: Int
    let name: String?
    let position: Int
    let options: [OrderOptionDataModel]?
}

struct OrderOptionDataModel: Codable {
    
    enum OptionType: String, Codable {
        case SELECT
        case PLAIN
        case AMOUNT
        case AMOUNT_THIRD
    }
    let id: Int
    let type: OptionType?
    let title: String?
    let values: [SimpleStringDataModel]?
}

struct SimpleStringDataModel: Codable, Hashable {
    let id: Int
    let value: String
}
