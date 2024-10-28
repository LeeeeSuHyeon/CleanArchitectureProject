//
//  UserListViewModel.swift
//  CleanArchitectureProject
//
//  Created by 이수현 on 10/28/24.
//

import Foundation


public protocol UserListViewModelProtocol {
    
}


public class UserListViewModel : UserListViewModelProtocol {
    let usecase : UserListUsecaseProtocol
    
    init(usecase: UserListUsecaseProtocol) {
        self.usecase = usecase
    }

//    1. VC에서 VM로 데이터를 전달 받고
    public struct Input {
        // 탭, 텍스트필드, 즐겨찾기 추가/삭제, 페이지네이션
        
    }
//    2. 가공 후 VM에서 VC로 데이터 전달
    public struct Output {
        // cell data (유저 리스트)
        // error -> VC에서 띄워야 하는 에러
    }
}
