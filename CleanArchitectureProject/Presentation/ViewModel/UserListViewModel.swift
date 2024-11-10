//
//  UserListViewModel.swift
//  CleanArchitectureProject
//
//  Created by 이수현 on 10/28/24.
//

import Foundation
import RxSwift
import RxCocoa


public protocol UserListViewModelProtocol {
    func transform(input : UserListViewModel.Input) -> UserListViewModel.Output
}
/*
 PublishRelay : 데이터를 VC에 전달하고자 하는 목적 (에러가 딱히 없음) - 초기값 필요 없음
 Subject : 데이터와 에러도 전달
 BehaviorRelay : 내부적으로 값을 접근해야 할 때(value) - 초기값 무조건 필요
 */

public class UserListViewModel : UserListViewModelProtocol {
    private let usecase : UserListUsecaseProtocol
    private let disposeBag = DisposeBag() // 바인딩 메모리 해제
    private let error = PublishRelay<String>() // API 에러, Core Data 에러 발생시 VC에게 에러 메시지 반환
    private let fetchUserList = BehaviorRelay<[UserListItem]>(value: []) // API 통해서 받아오는 유저 리스트
    private let allFavoriteUserList = BehaviorRelay<[UserListItem]>(value: []) // 즐겨찾기 포함 여부를 확인할 전체 즐겨찾기 리스트
    private let favoriteUserList = BehaviorRelay<[UserListItem]>(value: []) // 즐겨찾기 목록에 보여줄 리스트
    private var page = 0
    
    init(usecase: UserListUsecaseProtocol) {
        self.usecase = usecase
    }

//    1. VC에서 VM로 데이터를 전달 받고
    public struct Input {
        // 탭, 텍스트필드, 즐겨찾기 추가/삭제, 페이지네이션
        let tabButtonType : Observable<TabButtonType>
        let query : Observable<String>  // 텍스트 필드에서 전달될 쿼리 (API 호출 시 사용)
        let saveFavorite : Observable<UserListItem> // 저장될 유저 정보
        let deleteFavorite : Observable<Int> // 유저 아이디만 받으면 됨
        let fetchMore : Observable<Void> // 이벤트가 발생했다 정도만 알면 되기 때문에 받을 게 없음
        
    }
//    2. 가공 후 VM에서 VC로 데이터 전달
    public struct Output {
        // cell data (유저 리스트)
        let cellData : Observable<[UserListCellData]> // 즐겨찾기에서 초성을 헤더로 분리했기 때문에 UserListItem 타입을 사용하지 않음
        
        // error -> VC에서 띄워야 하는 에러
        let error : Observable<String> // 에러 타입은 필요없고 에러 메시지만 담으면 됨
    }
    
    // VC에서 이벤트가 전달되면 VM 데이터로 반환해주는 역할
    public func transform(input : Input) -> Output {
        input.query.bind {[weak self] query in // 텍스트 필드로 들어온 query 값을 받아서 사용
            //TODO:  User Fetch AND Get Favorite User
            
            guard let self = self, validateQuery(query: query)else {
                self?.getFavoriteUsers(query: "")
                return
            }
            page = 1
            fetchUser(query: query, page : page)
            getFavoriteUsers(query: query)
        }.disposed(by: disposeBag)
        
        input.saveFavorite
            .withLatestFrom(input.query, resultSelector: { user, query in
                return (user, query)
            })
            .bind {[weak self] user, query in
                
                //TODO: 즐겨찾기 추가
                self?.saveFavoriteUsers(user: user, query: query)
        }.disposed(by: disposeBag)
        
        input.deleteFavorite
            .withLatestFrom(input.query, resultSelector: { ($0, $1)})
            .bind {[weak self] userId, query in
                
                 //TODO: 즐겨찾기 삭제
                self?.deleteFavoriteUsers(userId : userId, query : query)
            
        }.disposed(by: disposeBag)
        
        input.fetchMore
            .withLatestFrom(input.query)
            .bind {[weak self] query in
            //TODO: 다음 페이지 검색
                guard let self = self else {return}
                page += 1
                print("fetchMore : \(page)")
                fetchUser(query: query, page: page)
        }.disposed(by: disposeBag)
        
        // 탭이 눌렸을 때, API 리스트를 가져올 건지, 즐겨찾기 유저를 가져올건지 탭이 결정함
        // bind 대신 map을 사용하는 이유 : cellData(Observable<[UserListCellData]>)로 반환되어야 되기 때문
             let cellData : Observable<[UserListCellData]> = Observable.combineLatest(input.tabButtonType, fetchUserList, favoriteUserList, allFavoriteUserList).map { [weak self] tabButtonType, fetchUserList, favoriteUserList, allFavoriteUserList in
            //TODO: cellData 생성
            var cellData : [UserListCellData] = []
            guard let self = self else {return cellData}
            
            switch tabButtonType {
            case .api :
                let tuple = usecase.checkFavoriteState(fetchUsers: fetchUserList, favoriteUsers: allFavoriteUserList)
                let result = tuple.map { user, isFavorite in
                    UserListCellData.user(user: user, isFavorite: isFavorite)
                }
                return result
            case .favorite:
                let dic = usecase.convertListToDictionary(favoriteUsers: favoriteUserList)
                let keys = dic.keys.sorted()
                keys.forEach { key in
                    cellData.append(.header(key))
                    if let users = dic[key] {
                        cellData += users.map{UserListCellData.user(user: $0, isFavorite: true)}
                    }
                }
            }
            return cellData
        }
        return Output(cellData: cellData, error: error.asObservable())
    }
    
    private func fetchUser(query : String, page : Int) {
        print("fetchUser - page : \(page)")
        guard let urlAllowedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
        
        Task{
            let result = await usecase.fetchUser(query: urlAllowedQuery, page: page)
            switch result {
            case .success(let users) :
                if page == 1 {
                    fetchUserList.accept(users.items)
                } else {
                    fetchUserList.accept(fetchUserList.value + users.items)
                }
                
            case .failure(let error) :
                self.error.accept(error.description)
            }
        }
    }
    
    private func getFavoriteUsers(query : String) {
        let result = usecase.getFavoriteUsers()
        switch result {
        case .success(let users):
            // 검색어가 없을 때
            if query.isEmpty {
                favoriteUserList.accept(users)
            }else { //
                let filteredUsers = users.filter { user in
                    user.login.contains(query.lowercased())
                }
                favoriteUserList.accept(filteredUsers)
            }
            allFavoriteUserList.accept(users)
        case .failure(let error):
            self.error.accept(error.description)
        }
    }
    
    
    public func saveFavoriteUsers(user : UserListItem, query : String) {
        let result = usecase.saveFavoriteUsers(user: user)
        switch result {
        case .success(_):
            getFavoriteUsers(query: query)
        case .failure(let error):
            self.error.accept(error.description)
        }
    }
    
    public func deleteFavoriteUsers(userId : Int, query : String){
        let result = usecase.deleteFavoriteUsers(userID: userId)
        switch result {
        case .success:
            getFavoriteUsers(query: query)
        case .failure(let error):
            self.error.accept(error.description)
        }
    }
    
    // 쿼리 유효성 검사
    private func validateQuery(query : String) -> Bool {
        // 추가로 특수문자 입력이나 이런 거 추가하면 좋을듯
        if query.isEmpty {
            return false
        } else {
            return true
        }
    }
}

// API 탭과 즐겨찾기 목록을 보여줄 탭 타입
public enum TabButtonType : String {
    case api = "API"
    case favorite = "Favorite"
}


public enum UserListCellData {
    case user(user: UserListItem, isFavorite : Bool)
    case header(String) // 초성
    
    var id : String {
        switch self {
        case .user:  UserTableViewCell.id
        case .header: UserHeaderTableViewCell.id
        }
    }
}
