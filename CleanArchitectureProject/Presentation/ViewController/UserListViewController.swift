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
    private lazy var tableView = UITableView()
    
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
        let output = viewModel.transform(input: UserListViewModel.Input(tabButtonType: tabButtonType, query: query.asObservable(), saveFavorite: saveFavorite.asObservable(), deleteFavorite: deleteFavorite.asObservable(), fetchMore: fetchMore.asObservable()))
        
        output.cellData.bind(to: tableView.rx.items){ tableView, index, item in
            
            return UITableViewCell()
        }.disposed(by: disposeBag)
        
        output.error.bind { error in
            let alert = UIAlertController(title: "에러", message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            self.present(alert, animated: true)
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


final class TabButtonView : UIStackView {
    private let tabList : [TabButtonType]
    private let disposeBag = DisposeBag()
    public var selectedType : BehaviorRelay<TabButtonType?>
    
    init(tabList: [TabButtonType]) {
        self.tabList = tabList
        selectedType = BehaviorRelay(value: tabList.first)
        super.init(frame: .zero)
        addButton()
        self.alignment = .fill
        self.distribution = .fillEqually
        (arrangedSubviews.first as? UIButton)?.isSelected = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addButton(){
        tabList.forEach { tabType in
            let button = TabButton(tabType: tabType)
            button.rx.tap.bind { [weak self] in
                self?.arrangedSubviews.forEach({ view in
                    (view as? UIButton)?.isSelected = false
                })
                button.isSelected = true
                self?.selectedType.accept(tabType)
            }.disposed(by: disposeBag)
            addArrangedSubview(button)
        }
    }
}

final class TabButton : UIButton {
    var tabType : TabButtonType
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = .systemCyan
            } else {
                backgroundColor = .white
            }
        }
    }
    init(tabType: TabButtonType) {
        self.tabType = tabType
        super.init(frame: .zero)
        
        self.setTitle(tabType.rawValue, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        
        self.setTitleColor(.white, for: .selected)
        self.setTitleColor(.black, for: .normal)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
