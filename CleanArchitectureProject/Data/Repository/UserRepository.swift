//
//  UserRepository.swift
//  CleanArchitectureProject
//
//  Created by 이수현 on 10/27/24.
//

import Foundation

public struct UserRepository : UserRepositoryProtocol{
    private let network : UserNetworkProtocol, coreData : UserCoreDataProtocol
    
    init(network: UserNetworkProtocol, coreData: UserCoreDataProtocol) {
        self.network = network
        self.coreData = coreData
    }
    
    public func fetchUser(query: String, page: Int) async -> Result<UserListResult, NetworkError> {
        await network.fetchUser(query: query, page: page)
    }
    
    public func getFavoriteUsers() -> Result<[UserListItem], CoreDataError> {
        coreData.getFavoriteUsers()
    }
    
    public func saveFavoriteUsers(user: UserListItem) -> Result<Bool, CoreDataError> {
        coreData.saveFavoriteUsers(user: user)
    }
    
    public func deleteFavoriteUsers(userID: Int) -> Result<Bool, CoreDataError> {
        coreData.deleteFavoriteUsers(userID: userID)
    }
    

    
}
