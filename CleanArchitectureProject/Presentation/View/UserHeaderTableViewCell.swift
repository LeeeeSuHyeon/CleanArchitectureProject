//
//  UserHeaderTableViewCell.swift
//  CleanArchitectureProject
//
//  Created by 이수현 on 11/4/24.
//

import UIKit

protocol UserTableViewCellProtocol {
    func apply(cellData : UserListCellData)
}

class UserHeaderTableViewCell: UITableViewCell, UserTableViewCellProtocol {
    static let id = "UserHeaderTableViewCell"
    private lazy var lblHeader = UILabel().then { lbl in
        lbl.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .systemGray5
        setUI()
    }
    
    private func setUI() {
        addSubview(lblHeader)
        
        lblHeader.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(6)
        }
    }
    
    public func apply(cellData : UserListCellData) {
        guard case .header(let title) = cellData else { return }
        lblHeader.text = title
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
