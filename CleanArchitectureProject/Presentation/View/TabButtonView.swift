//
//  TabButtonView.swift
//  CleanArchitectureProject
//
//  Created by 이수현 on 11/3/24.
//

import UIKit
import RxSwift
import RxCocoa

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
