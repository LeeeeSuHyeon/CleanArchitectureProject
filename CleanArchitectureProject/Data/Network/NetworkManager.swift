//
//  NetworkManager.swift
//  CleanArchitectureProject
//
//  Created by 이수현 on 10/26/24.
//

import Foundation
import Foundation
import Alamofire

public class NetworkManager {
    private let session : SessionProtocol
    
    init(session: SessionProtocol) {
        self.session = session
    }
    
    // header는 API Key 값
    private let tokenHeader : HTTPHeaders = {
        let tokenHeader = HTTPHeader(name: "Authorization", value: "Bearer Ov23lirfPWPyyZ67Dqwi")
        // 헤더가 여러개면 추가
        return HTTPHeaders([tokenHeader])
    }()
    
    func fetchData<T : Decodable>(url : String, method : HTTPMethod, parameters : Parameters?) async -> Result<T, NetworkError> {
        // url의 유효함 확인
        guard let url = URL(string: url) else { return .failure(.urlError) }
        
        
        let result = await session.request(url, method: method, parameters: parameters, headers: tokenHeader).serializingData().response

        if let error = result.error { return .failure(.requestFailed(error.localizedDescription)) }
        guard let data = result.data else {return .failure(.dataNil)}
        guard let response = result.response else {return .failure(.invalidResponse)}
        
        
        if 200..<400 ~= response.statusCode { // 성공
            // 데이터 파싱
            do {
                let data = try JSONDecoder().decode(T.self, from: data)
                return .success(data)
            } catch {
                return .failure(.failToDecode(error.localizedDescription))
            }
        } else {    // 실패
            return .failure(.serverError(response.statusCode))
        }
    }
}

//구현단 - NetworkManager(session: UserSession())
//테스트 - NetworkManager(session: MockSession())
