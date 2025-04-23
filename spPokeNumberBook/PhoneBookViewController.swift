//
//  PhoneBookViewController.swift
//  spPokeNumberBook
//
//  Created by Lee on 4/19/25.
//

import UIKit
import CoreData

class PhoneBookViewController: UIViewController {

   static var container: NSPersistentContainer?

    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 70
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.setTitle("랜덤 이미지 생성", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(imageChangeBtnTapped), for: .touchDown)
        return button
    }()

    let nameTextField: UITextField = {
        let textfield = UITextField()
        textfield.borderStyle = .roundedRect
        textfield.placeholder = "이름"
        textfield.font = .systemFont(ofSize: 15)
        return textfield
    }()

    let phoneNumberTextField: UITextField = {
        let textfield = UITextField()
        textfield.borderStyle = .roundedRect
        textfield.placeholder = "연락처"
        textfield.font = .systemFont(ofSize: 15)
        return textfield
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        setNavigationController()
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

    @objc func imageChangeBtnTapped() {
        let randomNumber = Int.random(in: 1...251)

        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(randomNumber)")
        guard let url else {
            return
        }

        try? fetchData(url: url) { [weak self] data in
            switch data {
            case .success(let data):
                guard let imageUrl = URL(string: "\(data.sprites.versions.generationSecond.gold.frontDefault)") else {
                    return
                }
                if let data = try? Data(contentsOf: imageUrl) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.profileImageView.image = image
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(error: error)
                }
            }
        }
    }
}

extension PhoneBookViewController {
    private func setNavigationController() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "연락처 추가"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "적용", style: .plain, target: self, action: #selector(buttonTapped))
    }

    @objc func buttonTapped() {
        let nameData = nameTextField.text ?? ""
        let phoneNumberData = phoneNumberTextField.text ?? ""
        guard let image = self.profileImageView.image?.pngData() else { return }
        createData(name: nameData, phoneNumber: phoneNumberData, image: image)
        navigationController?.popViewController(animated: true)
    }
}


extension PhoneBookViewController {
    private func fetchData(url: URL, completion: @escaping (Result<PocketmonData, CustomError>) -> Void) throws {
        let myUrlSession = URLSession(configuration: .default)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        myUrlSession.dataTask(with: request) { data, response, error in
            guard let data, error == nil else {
                completion(.failure(.dataError))
                return
            }

            let successRange = (200..<300)
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.responseFail))
                return
            }

            if successRange.contains(response.statusCode) {
                guard let decodedData = try? JSONDecoder().decode(PocketmonData.self, from: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                completion(.success(decodedData))
            }
        }.resume()
    }
}

extension PhoneBookViewController {
    func showAlert(error: CustomError) {
        let alert = UIAlertController(title: "오류", message: error.errorTitle, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

extension PhoneBookViewController {

    func createData(name: String, phoneNumber: String, image: Data) {
        guard let entity = NSEntityDescription.entity(forEntityName: PhoneBook.className, in: PhoneBookViewController.container!.viewContext) else { return }
        let newPhoneBook = NSManagedObject(entity: entity, insertInto: PhoneBookViewController.container?.viewContext)
        newPhoneBook.setValue(name, forKey: PhoneBook.Key.name)
        newPhoneBook.setValue(phoneNumber, forKey: PhoneBook.Key.phoneNumber)
        newPhoneBook.setValue(image, forKey: PhoneBook.Key.image)
        do {
            try PhoneBookViewController.container?.viewContext.save()
            print("연락처 저장 성공")
        } catch {
            print("연락처 저장 실패")
        }
    }
}
