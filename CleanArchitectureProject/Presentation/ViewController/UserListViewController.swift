//
//  ViewController.swift
//  CleanArchitectureProject
//
//  Created by 이수현 on 10/25/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class UserListViewController: UIViewController {
    
    private let viewModel : UserListViewModelProtocol
    private let disposeBag = DisposeBag()
    private let saveFavorite = PublishRelay<UserListItem>()
    private let deleteFavorite = PublishRelay<Int>()
    private let fetchMore = PublishRelay<Void>()
    
    private lazy var txtSearch = UITextField().then { text in
        text.layer.cornerRadius = 6
        text.layer.borderColor = UIColor.systemGray.cgColor
        text.layer.borderWidth = 1
        text.placeholder = "검색어를 입력해주세요."
        
        let leftView = UIImageView(image: .init(systemName: "magnifyingglass"))
        leftView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        text.leftView = leftView
        text.leftViewMode = .always
        text.tintColor = .black
    }
    
    private lazy var tabButtonView = TabButtonView(tabList: [.api, .favorite])
    private lazy var tableView = UITableView().then { view in
        view.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.id)
    }
    
    init(viewModel: UserListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .white
        
        setUI()
        bindViewModel()
        
    }
    
    private func bindViewModel() {
        let tabButtonType = tabButtonView.selectedType.compactMap{$0}
        let query = txtSearch.rx.text.orEmpty.debounce(.milliseconds(300), scheduler: MainScheduler.instance)
        let output = viewModel.transform(input: UserListViewModel.Input(tabButtonType: tabButtonType, query: query, saveFavorite: saveFavorite.asObservable(), deleteFavorite: deleteFavorite.asObservable(), fetchMore: fetchMore.asObservable()))
        
        output.cellData.bind(to: tableView.rx.items){[weak self] tableView, index, cellData in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.id) as? UserTableViewCell, case .user(let user, let favorite) = cellData else {return UITableViewCell()}
            
            cell.apply(cellData: cellData)
            cell.btnFavorite.rx.tap.bind {
                if favorite {
                    self?.deleteFavorite.accept(user.id)
                } else {
                    self?.saveFavorite.accept(user)
                }
            }.disposed(by: cell.disposeBag)
            return cell
            
        }.disposed(by: disposeBag)
        
        output.error.bind {[weak self] errorMessage in
            DispatchQueue.main.async{
                let alert = UIAlertController(title: "에러", message: errorMessage, preferredStyle: .alert)
                alert.addAction(.init(title: "확인", style: .default))
                self?.present(alert, animated: true)
            }

        }.disposed(by: disposeBag)
    }
    
    
    private func setUI(){
        view.addSubview(txtSearch)
        view.addSubview(tabButtonView)
        view.addSubview(tableView)
        
        txtSearch.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        tabButtonView.snp.makeConstraints { make in
            make.top.equalTo(txtSearch.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(tabButtonView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


