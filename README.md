# CleanArchitectureProject

이 리포지토리는 [인프런 Clean Architecture와 RxSwift iOS 강의](https://www.inflearn.com/course/ios-clean-architecutre-rxswift)를 수강하면서 작성되었습니다.  
이 강의는 **Clean Architecture**, **MVVM**, **RxSwift**, **모듈화**를 중심으로 iOS 앱 개발을 다룹니다.

## 목차
- [프로젝트 소개](#프로젝트-소개)
- [주요 기능](#주요-기능)
- [기술 스택 및 프레임워크](#기술-스택-및-프레임워크)
- [클린 아키텍처 구조](#클린-아키텍처-구조)
- [디렉터리 구조](#디렉터리-구조)
- [시연 영상](#시연-영상)
  
## 프로젝트 소개
이 프로젝트는 GitHub API를 활용하여 사용자 검색, 즐겨찾기 관리, 페이지네이션 기능을 제공하는 iOS 앱입니다.   
**Clean Architecture** 원칙과 **RxSwift** 기반의 비동기 프로그래밍을 적용하여 구현했습니다.

## 주요 기능
- **사용자 검색**: GitHub API를 통해 사용자 검색 기능을 제공합니다.
- **즐겨찾기 관리**: 특정 사용자를 즐겨찾기에 추가하거나 제거할 수 있습니다.
- **페이지네이션**: 많은 데이터셋을 효율적으로 다룰 수 있도록 RxSwift 기반 페이지네이션을 구현했습니다.

## 기술 스택 및 프레임워크
- **언어**: Swift
- **아키텍처**: 클린 아키텍처 (SOLID 원칙 적용)
- **반응형 프로그래밍**: RxSwift로 비동기 작업 및 이벤트 처리
- **네트워킹**: Alamofire로 API 요청 관리
- **테스트**: XCTest로 단위 테스트 및 RxTest로 반응형 코드 테스트
- **프레임워크/라이브러리**
    - **UIKit** : UI 구현
    - **CoreData** : 즐겨찾기 유저 데이터 저장 (유저 번호, 아이디, 이미지 URL)
    - **XCTest** : 테스트케이스 작성
    - **RxSwift** : 비동기 프로그래밍
    - **RxCocoa** : 비동기 프로그래밍
    - **SnapKit** : 레이아웃 구현
    - **Alamofire** : API 통신
    - **Kingfisher** : 이미지 캐싱
    - **Then** : 컴포넌트 init

## 클린 아키텍처 구조
본 프로젝트는 **클린 아키텍처** 구조를 따라 코드를 독립적인 계층으로 나누어 구성했습니다.
1. **Presentation Layer**: UI와 사용자 입력을 관리합니다.
   - `ViewController`와 `ViewModel`, `View`를 사용하여 `RxSwift`로 바인딩 및 사용자 상호작용을 처리합니다.
2. **Domain Layer**: 비즈니스 로직을 포함합니다.
   - `Usecase` :`Presentation, Data Layer` 간 데이터 흐름을 처리합니다.
   - `Entity` : API 응답 데이터 구조와, 에러 구조를 정의합니다.
   - `RepositoryProtocol` : 의존성 역전 원칙을 준수하기 위해 `Usecase`에서 사용할 `Repository`를 프로토콜로 정의하여 고수준 모듈로 구현합니다.
3. **Data Layer**: API 호출과 로컬 데이터 관리를 담당합니다.
   - `Repository` : API를 연결할지, Core Data를 사용할지 구분합니다.
   - `Core Data` : Swift 자체 DB인 Core Data를 활용해 데이터를 저장합니다.
   - `Network` : `UseCase` 중 API 연결을 필요로 하는 기능을 구현합니다.
     - 의존성 주입이 적용된 **NetworkManager**를 통해 유연성과 테스트 가능성을 높였습니다.

## 디렉터리 구조
```
📦CleanArchitectureProject
 ┣ 📜AppDelegate
 ┣ 📜SceneDelegate
 ┣ 📂Data
 ┃ ┣ 📂CoreData
 ┃ ┃ ┗ 📜UserCoreData
 ┃ ┣ 📂Network
 ┃ ┃ ┣ 📜NetworkManager
 ┃ ┃ ┣ 📜UserNetwork
 ┃ ┃ ┗ 📜UserSession
 ┃ ┣ 📂Repository
 ┃ ┃ ┗ 📜UserRepository
 ┣ 📂Domain
 ┃ ┣ 📂Entity
 ┃ ┃ ┣ 📜CoreDataError
 ┃ ┃ ┣ 📜NetworkError
 ┃ ┃ ┗ 📜UserListItem
 ┃ ┣ 📂RepositoryProtocol
 ┃ ┃ ┗ 📜UserRepositoryProtocol
 ┃ ┣ 📂Usecase
 ┃ ┃ ┗ 📜UserListUsecase
 ┣ 📂Presentation
 ┃ ┣ 📂View
 ┃ ┃ ┣ 📜TabButtonView
 ┃ ┃ ┣ 📜UserHeaderTableViewCell
 ┃ ┃ ┗ 📜UserTableViewCell
 ┃ ┣ 📂ViewController
 ┃ ┃ ┗ 📜UserListViewController
 ┃ ┣ 📂ViewModel
 ┃ ┃ ┗ 📜UserListViewModel
 ┗ 📜Info.plist
 
```

## 시연 영상
<img src = "https://github.com/user-attachments/assets/239290d8-185d-4fcc-a9b9-bcfa89a1391c" height=650 width=300>
