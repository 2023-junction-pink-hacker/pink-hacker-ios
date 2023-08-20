//
//  APIRequest.swift
//  PinkHacker
//
//  Created by 김가영 on 2023/08/19.
//

import Foundation
import Alamofire
import Combine

enum APIError: Error {
    case unknown
}

class APIRequest<Response: Codable> {
    let host = "http://ec2-3-35-213-48.ap-northeast-2.compute.amazonaws.com"
    let path: String
    
    init(path: String) {
        self.path = path
    }
    
    func publisher() -> AnyPublisher<Response, APIError> {
        AF.request(URL(string: "\(host)\(path)")!)
            .publishDecodable(type: Response.self)
            .value()
            .mapError { error in
                print("# error: \(error)")
                return APIError.unknown
            }
            .eraseToAnyPublisher()
    }
    
    func putPublisher(_ body: Encodable) -> AnyPublisher<Response, APIError> {
        var request = APIRequest(path: "\(host)\(path)")
        print("# \(body.dictionary)")
        return AF.request(URL(string: "\(host)\(path)")!, method: .put, parameters: body.dictionary)
            .publishDecodable(type: Response.self)
            .value()
            .mapError { error in
                print("# error: \(error)")
                return APIError.unknown
            }
            .eraseToAnyPublisher()
    }
}

private extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
