//
//  UserNetwork.swift
//  CleanArchitectureProject
//
//  Created by 이수현 on 10/26/24.
//


public protocol UserNetworkProtocol {
    func fetchUser(query: String, page: Int) async -> Result<UserListResult, NetworkError>
}


final class UserNetwork : UserNetworkProtocol{
    private let manage : NetworkManagerProtocol
    
    init(manage: NetworkManagerProtocol) {
        self.manage = manage
    }
    
    func fetchUser(query: String, page: Int) async -> Result<UserListResult, NetworkError> {
        let url = "https://api.github.com/search/users?q=\(query)&page=\(page)"
        return await manage.fetchData(url: url, method: .get, parameters: nil)
    }
}
