//
//  UserListUsecase.swift
//  CleanArchitectureProject
//
//  Created by 이수현 on 10/25/24.
//

import Foundation

public protocol UserListUsecaseProtocol {
    func fetchUser(query : String, page : Int) async -> Result<UserListResult, NetworkError> // 유저 리스트 불러오기 (검색)
    func getFavoriteUsers() -> Result<[UserListItem], CoreDataError>    // 전체 즐겨찾기 리스트 가져오기
    func saveFavoriteUsers(user : UserListItem) -> Result<Bool, CoreDataError>  // 즐겨찾기 저장
    func deleteFavoriteUsers(userID : Int) -> Result<Bool, CoreDataError>       // 즐겨찾기 삭제
    func checkFavoriteState(fetchUsers : [UserListItem], favoriteUsers : [UserListItem]) -> [(user : UserListItem, isFavorite : Bool)] // 유저리스트 - 즐겨찾기 포함한 유저인지 구분
    func convertListToDictionary(favoriteUsers : [UserListItem]) -> [String : [UserListItem]] // 배열 -> Dictionary [초성 : [유저 리스트]]

    
    /* 추가해야 할 내용
      1. 배열 -> Dictionary [초성 : [유저 리스트]]
      2. 유저리스트 - 즐겨찾기 포함한 유저인지 구분
    */
    
}

public struct UserListUsecase : UserListUsecaseProtocol {
    private let repository : UserRepositoryProtocol
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    public func fetchUser(query: String, page: Int) async -> Result<UserListResult, NetworkError> {
        return await repository.fetchUser(query: query, page: page)
    }
    
    public func getFavoriteUsers() -> Result<[UserListItem], CoreDataError> {
        repository.getFavoriteUsers()
    }
    
    public func saveFavoriteUsers(user: UserListItem) -> Result<Bool, CoreDataError> {
        repository.saveFavoriteUsers(user: user)
    }
    
    public func deleteFavoriteUsers(userID: Int) -> Result<Bool, CoreDataError> {
        repository.deleteFavoriteUsers(userID: userID)
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
