//
//  TableViewCell.swift
//  spPokeNumberBook
//
//  Created by Lee on 4/17/25.
//

import UIKit

class TableViewCell: UITableViewCell {

    static let id = "TableViewCell"

    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()

    let phoneNumLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()

    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 25
        imageView.backgroundColor = .white
        imageView.clipsToBounds = true
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        [profileImageView, nameLabel, phoneNumLabel].forEach { contentView.addSubview($0) }

        profileImageView.snp.makeConstraints {
            $0.height.width.equalTo(50)
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.leading.equalTo(contentView.snp.leading).offset(20)
        }

        nameLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView.snp.centerY)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(20)
        }

        phoneNumLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView.snp.centerY)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-20)
        }
    }

    func configureCell(phoneBookData: PhoneBook) {
        self.nameLabel.text = phoneBookData.name
        self.phoneNumLabel.text = phoneBookData.phoneNumber
        guard let profileImage = phoneBookData.image else { return }
        self.profileImageView.image = UIImage(data: profileImage, scale: 1.3)
    }
}

