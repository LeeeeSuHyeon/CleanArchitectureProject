//
//  UserUsecaseTests.swift
//  CleanArchitectureProjectTests
//
//  Created by 이수현 on 10/27/24.
//

import XCTest
@testable import CleanArchitectureProject

final class UserUsecaseTests: XCTestCase {
    var usecase : UserListUsecaseProtocol!
    var repository : UserRepositoryProtocol!
    
    override func setUp() {
        super.setUp()
        
        repository = MockUserRepository()
        usecase = UserListUsecase(repository: repository)
    }
    
    func testCheckFavoriteState() {
        let fetchUsers : [UserListItem] = [
            UserListItem(id: 1, login: "user1", imageURL: ""),
            UserListItem(id: 2, login: "user2", imageURL: ""),
            UserListItem(id: 3, login: "user3", imageURL: ""),
            UserListItem(id: 4, login: "user4", imageURL: "")
        ]
        
        let favoriteUsers = [
            UserListItem(id: 1, login: "user1", imageURL: ""),
            UserListItem(id: 2, login: "user2", imageURL: ""),
        ]
        
        let result = usecase.checkFavoriteState(fetchUsers: fetchUsers, favoriteUsers: favoriteUsers)
        
        XCTAssertEqual(result[0].isFavorite, true)
        XCTAssertEqual(result[1].isFavorite, true)
        XCTAssertEqual(result[2].isFavorite, false)
        XCTAssertEqual(result[3].isFavorite, false)
    }
    
    func testConverListToDictionary() {
        let favoriteUsers = [
            UserListItem(id: 1, login: "Alice", imageURL: ""),
            UserListItem(id: 2, login: "Bob", imageURL: ""),
            UserListItem(id: 3, login: "James", imageURL: ""),
            UserListItem(id: 4, login: "ash", imageURL: "")
        ]
        let result = usecase.convertListToDictionary(favoriteUsers: favoriteUsers)
        
        XCTAssertEqual(result.keys.count, 3)
        XCTAssertEqual(result["A"]?.count, 2)
        XCTAssertEqual(result["B"]?.count, 1)
        XCTAssertEqual(result["J"]?.count, 1)
    }
    
    override func tearDown() {
        usecase = nil
        repository = nil
        super.tearDown()
    }
}
