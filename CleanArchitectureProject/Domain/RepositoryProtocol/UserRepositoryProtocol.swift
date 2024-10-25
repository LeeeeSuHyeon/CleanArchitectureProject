//
//  UserRepositoryProtocol.swift
//  CleanArchitectureProject
//
//  Created by 이수현 on 10/25/24.
//

import Foundation

public protocol UserRepositoryProtocol {
    func fetchUser(query : String, page : Int) async -> Result<UserListResult, NetworkError> // 유저 리스트 불러오기 (검색)
    func getFavoriteUsers() -> Result<[UserListItem], CoreDataError>    // 전체 즐겨찾기 리스트 가져오기
    func saveFavoriteUsers(user : UserListItem) -> Result<Bool, CoreDataError>  // 즐겨찾기 저장
    func deleteFavoriteUsers(userID : Int) -> Result<Bool, CoreDataError>       // 즐겨찾기 삭제
}
