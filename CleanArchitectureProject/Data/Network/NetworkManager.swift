//
//  UserNetworkManager.swift
//  CleanArchitectureProject
//
//  Created by 이수현 on 11/4/24.
//

import Foundation
import Alamofire
import Then

public protocol NetworkManagerProtocol {
    func fetchData<T : Decodable>(url : String, method : HTTPMethod, parameters : Parameters?) async -> Result<T, NetworkError>
}


public class NetworkManager : NetworkManagerProtocol{
    private let session : SessionProtocol
    init(session: SessionProtocol) {
        self.session = session
    }
    
    private let tokenHeader : HTTPHeaders = {
        let APIKey = Bundle.main.infoDictionary?["APIKey"] as? String ?? ""
        let tokenHeader = HTTPHeader(name: "Authorization", value: "Bearer \(APIKey)")
        return HTTPHeaders([tokenHeader])
    }()
    
    public func fetchData<T : Decodable>(url : String, method : HTTPMethod, parameters : Parameters?) async -> Result<T, NetworkError> {
        guard let url = URL(string: url) else {return .failure(.urlError)}
        let result = await session.request(url, method: method, parameters: parameters, headers: tokenHeader).serializingData().response
        if let error = result.error { return .failure(.requestFailed(error.localizedDescription))}
        guard let data = result.data else {return .failure(.dataNil)}
        guard let response = result.response else {return .failure(.invalidResponse)}
        if 200..<400 ~= response.statusCode {
            do {
                let data = try JSONDecoder().decode(T.self, from: data)
                return .success(data)
            } catch {
                return .failure(.failToDecode(error.localizedDescription))
            }
        } else {
            return .failure(.serverError(response.statusCode))
        }
    }
}


//구현단 - NetworkManager(session: UserSession())
//테스트 - NetworkManager(session: MockSession())
