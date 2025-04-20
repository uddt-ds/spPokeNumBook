//
//  PhoneBookViewController.swift
//  spPokeNumberBook
//
//  Created by Lee on 4/19/25.
//

import UIKit

class PhoneBookViewController: UIViewController {
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "")
        imageView.layer.cornerRadius = 70
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.gray.cgColor
        return imageView
    }()

    let createButton: UIButton = {
        let button = UIButton()
        button.setTitle("랜덤 이미지 생성", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        return button
    }()

    let nameTextField: UITextField = {
        let textfield = UITextField()
        textfield.borderStyle = .roundedRect
        textfield.font = .systemFont(ofSize: 15)
        return textfield
    }()

    let phoneNumberTextField: UITextField = {
        let textfield = UITextField()
        textfield.borderStyle = .roundedRect
        textfield.font = .systemFont(ofSize: 15)
        return textfield
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }

    private func configureUI() {
        view.backgroundColor = .white

        [profileImageView, createButton, nameTextField, phoneNumberTextField].forEach { view.addSubview($0) }

        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(140)
            $0.top.equalToSuperview().offset(120)
            $0.centerX.equalToSuperview()
        }

        createButton.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }

        nameTextField.snp.makeConstraints {
            $0.top.equalTo(createButton.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(40)
        }

        phoneNumberTextField.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(40)
        }
    }
}
