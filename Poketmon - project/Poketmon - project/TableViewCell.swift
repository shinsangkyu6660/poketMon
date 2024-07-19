//
//  TableViewCell.swift
//  Poketmon - project
//
//  Created by 신상규 on 7/15/24.
//

import UIKit
import SnapKit
import CoreData

class TableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        reloadTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        let profileImage: UIImageView = {
            let profileImage = UIImageView()
            profileImage.layer.cornerRadius = 25
            profileImage.layer.borderColor = UIColor.gray.cgColor
            profileImage.layer.borderWidth = 1
            profileImage.clipsToBounds = true
            return profileImage
        }()
        
        let nameLabelText: UILabel = {
            let nameLabel = UILabel()
            nameLabel.textColor = .black
            nameLabel.font = .boldSystemFont(ofSize: 15)
            return nameLabel
        }()
        
        let phoneLabelText: UILabel = {
            let phoneLabel = UILabel()
            phoneLabel.textColor = .black
            phoneLabel.font = .boldSystemFont(ofSize: 15)
            return phoneLabel
        }()
    
    func reloadTableView() {
        [profileImage, nameLabelText, phoneLabelText].forEach { contentView.addSubview($0) }
        
        profileImage.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(50)
        }
        
        nameLabelText.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(profileImage.snp.trailing).offset(50)
        }
    
        phoneLabelText.snp.makeConstraints{
            $0.centerY.equalTo(profileImage.snp.centerY)
            
            $0.leading.equalTo(nameLabelText.snp.trailing).offset(100)
        }
    }
}
