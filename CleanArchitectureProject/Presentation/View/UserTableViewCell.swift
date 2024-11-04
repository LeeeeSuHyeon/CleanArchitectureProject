//
//  UserTableViewCell.swift
//  CleanArchitectureProject
//
//  Created by 이수현 on 11/3/24.
//

import Foundation
import UIKit
import Kingfisher
import RxSwift

class UserTableViewCell : UITableViewCell {
    static let id = "UserTableViewCell"
    public var disposeBag = DisposeBag()
    
    private lazy var userImageView = UIImageView().then { view in
        view.layer.cornerRadius = 6
        view.layer.borderColor = UIColor.systemGray.cgColor
        view.layer.borderWidth = 0.5
        view.clipsToBounds = true
    }
    
    private lazy var lblUserName = UILabel().then { lbl in
        lbl.font = .systemFont(ofSize: 14, weight: .semibold)
        lbl.numberOfLines = 2
    }
    
    public lazy var btnFavorite = UIButton().then { btn in
        btn.setImage(.init(systemName: "heart"), for: .normal)
        btn.setImage(.init(systemName: "heart.fill"), for: .selected)
        btn.tintColor = .systemRed
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    private func setUI() {
        contentView.addSubview(userImageView)
        contentView.addSubview(lblUserName)
        contentView.addSubview(btnFavorite)
        
        userImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(20)
            make.width.height.equalTo(80)
        }
        
        lblUserName.snp.makeConstraints { make in
            make.top.equalTo(userImageView)
            make.leading.equalTo(userImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(20)
        }
        
        btnFavorite.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    public func apply(cellData : UserListCellData) {
        guard case .user(let user, let isFavorite) = cellData else { return }

        lblUserName.text = user.login
        userImageView.kf.setImage(with: URL(string: user.imageURL))
        btnFavorite.isSelected = isFavorite
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
