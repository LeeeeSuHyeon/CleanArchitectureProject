//
//  UserTableViewCell.swift
//  CleanArchitectureProject
//
//  Created by 이수현 on 11/3/24.
//

import Foundation
import UIKit
import Kingfisher

class UserTableViewCell : UITableViewCell {
    static let id = "UserTableViewCell"
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    private func setUI() {
        addSubview(userImageView)
        addSubview(lblUserName)
        
        userImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(20)
            make.width.height.equalTo(80)
        }
        
        lblUserName.snp.makeConstraints { make in
            make.top.equalTo(userImageView)
            make.leading.equalTo(userImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    public func apply(cellData : UserListCellData) {
        guard case .user(let user, let isFavorite) = cellData else { return }

        lblUserName.text = user.login
        userImageView.kf.setImage(with: URL(string: user.imageURL))
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
