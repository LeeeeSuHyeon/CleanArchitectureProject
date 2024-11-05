//
//  UserListViewModelTests.swift
//  CleanArchitectureProjectTests
//
//  Created by 이수현 on 11/5/24.
//

import Foundation
import XCTest
import RxSwift
import RxCocoa
@testable import CleanArchitectureProject

final class UserListViewModelTests : XCTestCase {
    
    private var viewModel : UserListViewModel!
    private var mockUsecase : MockUsecase!
    
    private var tabButtonType : BehaviorRelay<TabButtonType>!
    private var query : BehaviorRelay<String>!  // 텍스트 필드에서 전달될 쿼리 (API 호출 시 사용)
    private var saveFavorite : PublishRelay<UserListItem>! // 저장될 유저 정보
    private var deleteFavorite : PublishRelay<Int>! // 유저 아이디만 받으면 됨
    private var fetchMore : PublishRelay<Void>! // 이벤트가 발생했다 정도만 알면 되기 때문에 받을 게 없음
    private var input :  UserListViewModel.Input!
    
    private var disposeBag : DisposeBag!
    
    override func setUp() {
        super.setUp()
        
        mockUsecase = MockUsecase()
        viewModel = UserListViewModel(usecase: mockUsecase)
        tabButtonType = BehaviorRelay<TabButtonType>(value: .api)
        query = BehaviorRelay<String>(value : "")
        saveFavorite = PublishRelay<UserListItem>()
        deleteFavorite = PublishRelay<Int>()
        fetchMore = PublishRelay<Void>()
        disposeBag = DisposeBag()
        
        input = UserListViewModel.Input(tabButtonType: tabButtonType.asObservable(), query: query.asObservable(), saveFavorite: saveFavorite.asObservable(), deleteFavorite: deleteFavorite.asObservable(), fetchMore: fetchMore.asObservable())
    }
    
    // 쿼리 결과 cellData로 잘 나오는지 테스트
    func testFetchUserCellData() {
        let userList = [
            UserListItem(id: 1, login: "user1", imageURL: ""),
            UserListItem(id: 2, login: "user2", imageURL: ""),
            UserListItem(id: 3, login: "user3", imageURL: ""),
        ]

        mockUsecase.fetchUserResult = .success(UserListResult(totalCount: 3, incompleteResults: false, items: userList)
)
        
        let output = viewModel.transform(input: input)
        var result = [UserListCellData]()
        query.accept("user")
        
        output.cellData.bind { cellData in
            result = cellData
        }.disposed(by: disposeBag)
        
        if case let .user(user, _) = result.first {
            XCTAssertEqual(user.login, "user1")
            XCTAssertEqual(user.id, 1)
        } else {
            XCTFail("userListItem 아님")
        }
        
        if case let .user(user, _) = result[1] {
            XCTAssertEqual(user.login, "user2")
            XCTAssertEqual(user.id, 2)
        } else {
            XCTFail("userListItem 아님")
        }
    }
    
    
    // 즐겨찾기 결과 cell 잘 나오는지 테스트
    func testFavoriteUserCellData() {
        let userList = [
            UserListItem(id: 1, login: "Alice", imageURL: ""),
            UserListItem(id: 2, login: "Bob", imageURL: ""),
            UserListItem(id: 3, login: "brand", imageURL: ""),
        ]
        
        mockUsecase.getFavoriteUsersResult = .success(userList)
        let output = viewModel.transform(input: input)
        var result = [UserListCellData]()
        tabButtonType.accept(.favorite)
        output.cellData.bind { cellData in
            result = cellData
        }.disposed(by: disposeBag)
        
        if case let .header(string) = result[0] {
            XCTAssertEqual(string, "A")
        } else {
            XCTFail("헤더 아님")
        }
        
        if case let .user(user, isFavorite) = result[1] {
            XCTAssertEqual(user.login, "Alice")
            XCTAssertEqual(user.id, 1)
            XCTAssertTrue(isFavorite)
        } else {
            XCTFail("user 아님")
        }
        if case let .header(string) = result[2] {
            XCTAssertEqual(string, "B")
        } else {
            XCTFail("헤더 아님")
        }
        
        if case let .user(user, isFavorite) = result[3] {
            XCTAssertEqual(user.login, "Bob")
            XCTAssertEqual(user.id, 2)
            XCTAssertTrue(isFavorite)
        } else {
            XCTFail("user 아님")
        }
        
        if case let .user(user, isFavorite) = result[4] {
            XCTAssertEqual(user.login, "brand")
            XCTAssertEqual(user.id, 3)
            XCTAssertTrue(isFavorite)
        } else {
            XCTFail("user 아님")
        }
        
    }
    
    override func tearDown() {
        super.tearDown()
        
        viewModel = nil
        mockUsecase = nil
        input = nil
    }
}
