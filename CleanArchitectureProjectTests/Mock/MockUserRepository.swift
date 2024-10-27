//
//  MockUserRepository.swift
//  CleanArchitectureProjectTests
//
//  Created by 이수현 on 10/27/24.
//

import Foundation
@testable import CleanArchitectureProject

public struct MockUserRepository : UserRepositoryProtocol {
    public func fetchUser(query: String, page: Int) async -> Result<CleanArchitectureProject.UserListResult, CleanArchitectureProject.NetworkError> {
        .failure(.dataNil)
    }
    
    public func getFavoriteUsers() -> Result<[CleanArchitectureProject.UserListItem], CleanArchitectureProject.CoreDataError> {
        .failure(.readError(""))
    }
    
    public func saveFavoriteUsers(user: CleanArchitectureProject.UserListItem) -> Result<Bool, CleanArchitectureProject.CoreDataError> {
        .failure(.readError(""))
    }
    
    public func deleteFavoriteUsers(userID: Int) -> Result<Bool, CleanArchitectureProject.CoreDataError> {
        .failure(.readError(""))
    }
    

    
    
}
