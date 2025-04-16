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
        label.text = "name"
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()

    let phoneNumLabel: UILabel = {
        let label = UILabel()
        label.text = "010-0000-0000"
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {

        let imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.image = UIImage(named: "")
            imageView.layer.borderColor = UIColor.black.cgColor
            imageView.layer.borderWidth = 1
            imageView.layer.cornerRadius = 25
            return imageView
        }()

        [imageView, nameLabel, phoneNumLabel].forEach { contentView.addSubview($0) }

        imageView.snp.makeConstraints {
            $0.height.width.equalTo(50)
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.leading.equalTo(contentView.snp.leading).offset(20)
        }

        nameLabel.snp.makeConstraints {
            $0.centerY.equalTo(imageView.snp.centerY)
            $0.leading.equalTo(imageView.snp.trailing).offset(20)
        }

        phoneNumLabel.snp.makeConstraints {
            $0.centerY.equalTo(imageView.snp.centerY)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-20)
        }
    }
}
