//
//  UserSession.swift
//  CleanArchitectureProject
//
//  Created by 이수현 on 10/26/24.
//

import Foundation
import Alamofire


public protocol SessionProtocol {
    func request(_ convertible: any URLConvertible,
                 method: HTTPMethod,
                 parameters: Parameters?,
                 headers: HTTPHeaders?) -> DataRequest
}

// Session
class UserSession : SessionProtocol {
    private var session : Session
    
    init(session: Session) {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        self.session = Session(configuration: config)
    }
    
    func request(_ convertible: any URLConvertible,
                 method: HTTPMethod = .get,
                 parameters: Parameters? = nil,
                 headers: HTTPHeaders? = nil) -> DataRequest {
        return session.request(convertible, method: method, parameters: parameters, headers: headers)
    }
}
