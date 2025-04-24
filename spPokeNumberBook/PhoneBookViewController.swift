//
//  PhoneBookViewController.swift
//  spPokeNumberBook
//
//  Created by Lee on 4/19/25.
//

import UIKit
import CoreData

class PhoneBookViewController: UIViewController {

    // coreData를 담는 container
   static var container: NSPersistentContainer?

    // MARK: PhoneBook에 데이터가 있는지 확인하는 flag
    var isEditingBook: PhoneBook?

    lazy var profileImageView: UIImageView = {
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

    //MARK: UI를 view에 반영해주는 메서드
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

    //MARK: 랜덤 이미지 버튼 event
    @objc func imageChangeBtnTapped() {
        let randomNumber = Int.random(in: 1...251)

        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(randomNumber)")
        guard let url else {
            return
        }

        //MARK: 데이터를 불러오는 메서드
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

    //MARK: 적용 버튼 event
    @objc func buttonTapped() {
        // isEditiongBook을 사용하여 분기처리
        if isEditingBook == nil {
            createBookList()
        } else {
            guard let updateBook = isEditingBook else { return }
            updateBookList(phoneBook: updateBook)
        }
        navigationController?.popViewController(animated: true)
    }
}


extension PhoneBookViewController {
    private func setNavigationController() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "연락처 추가"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "적용", style: .plain, target: self, action: #selector(buttonTapped))
    }
}


extension PhoneBookViewController {
    //MARK: 데이터를 불러오는 로직
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
    //MARK: 데이터를 생성하는 로직
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

    //MARK: 데이터를 생성하는 메서드
    private func createBookList() {
        let nameData = nameTextField.text ?? ""
        let phoneNumberData = phoneNumberTextField.text ?? ""
        if nameData.isEmpty || phoneNumberData.isEmpty {
            showAlert(error: .mustInput)
            return
        }
        guard let image = self.profileImageView.image?.pngData() else {
            showAlert(error: .mustImage)
            return
        }

        createData(name: nameData, phoneNumber: phoneNumberData, image: image)
    }

    //MARK: 데이터를 업데이트하는 메서드
    private func updateBookList(phoneBook: PhoneBook) {
        let nameData = nameTextField.text ?? ""
        let phoneNumberData = phoneNumberTextField.text ?? ""
        if nameData.isEmpty || phoneNumberData.isEmpty {
            showAlert(error: .mustInput)
            return
        }
        guard let image = self.profileImageView.image?.pngData() else {
            showAlert(error: .mustImage)
            return
        }

        phoneBook.name = nameData
        phoneBook.phoneNumber = phoneNumberData
        phoneBook.image = image

        do {
            try PhoneBookViewController.container?.viewContext.save()
            print("연락처 저장 성공")
        } catch {
            print("연락처 저장 실패")
        }
    }
}

extension PhoneBookViewController {
    //MARK: alert 생성하는 메서드
    func showAlert(error: CustomError) {
        let alert = UIAlertController(title: "오류", message: error.errorTitle, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
