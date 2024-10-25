//
//  NetworkError.swift
//  CleanArchitectureProject
//
//  Created by 이수현 on 10/25/24.
//

import Foundation

public enum NetworkError : Error {
    case urlError   // URL에 문제가 있을 때, 호출 전, request 단에서 처리
    case invalid    // 유효하지 않은 응답 값을 받을 때
    case failToDecode(String)   // 데이터 파싱에서 에러가 났을 때 (에러 설명을 파라미터로 받음)
    case dataNil    // 응답에 데이터가 없을 때
    case serverError(Int)   // 서버에서 던져주는 에러 처리가 필요할 때 (해당 오류의 status 코드를 받음)
    case requestFailed(String)  // 특정 이유로 서버 요청에 실패했을 때  (인터넷 오류)
    
    // presentation에서 해당 에러를 toast, alert을 띄울 때 description 정의
    public var description : String {
        switch self {
        case .urlError:
            "URL이 올바르지 않습니다."
        case .invalid:
            "응답값이 유효하지 않습니다."
        case .failToDecode(let description):
            "디코딩 에러 : \(description)"
        case .dataNil:
            "데이터가 없습니다."
        case .serverError(let statusCode):
            "서버 에러 : \(statusCode)"
        case .requestFailed(let message):
            "서버 요청 실패 : \(message)"
        }
    }
}
