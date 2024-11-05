//
//  MockUsecase.swift
//  CleanArchitectureProjectTests
//
//  Created by 이수현 on 11/5/24.
//

import Foundation
import RxSwift
import RxCocoa
@testable import CleanArchitectureProject

final class MockUsecase : UserListUsecaseProtocol {
    var fetchUserResult : Result<UserListResult, NetworkError>?
    var getFavoriteUsersResult : Result<[UserListItem], CoreDataError>?
    
    func fetchUser(query: String, page: Int) async -> Result<CleanArchitectureProject.UserListResult, CleanArchitectureProject.NetworkError> {
        fetchUserResult ?? .failure(.dataNil)
    }
    
    func getFavoriteUsers() -> Result<[CleanArchitectureProject.UserListItem], CleanArchitectureProject.CoreDataError> {
        getFavoriteUsersResult ?? .failure(.deleteError(""))
    }
    
    func saveFavoriteUsers(user: CleanArchitectureProject.UserListItem) -> Result<Bool, CleanArchitectureProject.CoreDataError> {
        .success(true)
    }
    
    func deleteFavoriteUsers(userID: Int) -> Result<Bool, CleanArchitectureProject.CoreDataError> {
        .success(true)
    }
    
    public func checkFavoriteState(fetchUsers: [UserListItem], favoriteUsers: [UserListItem]) -> [(user: UserListItem, isFavorite: Bool)] {
        let favoriteSet = Set(favoriteUsers) // Set에 들어가기 위해서 UserListItem은 Hashable이어야 함
        return fetchUsers.map { user in
            return favoriteSet.contains(user) ? (user : user, isFavorite : true) : (user : user, isFavorite : false)
        }
    }
    
    public func convertListToDictionary(favoriteUsers: [UserListItem]) -> [String : [UserListItem]] {
        return favoriteUsers.reduce(into: [String : [UserListItem]]()) { partialResult, user in
            if let firstString = user.login.first { // 초성
                let key = String(firstString).uppercased()  // 대문자
                partialResult[key, default: []].append(user)
            }
        }
    }
    
    
}
