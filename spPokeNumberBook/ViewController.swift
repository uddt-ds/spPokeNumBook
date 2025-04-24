//
//  ViewController.swift
//  spPokeNumberBook
//
//  Created by Lee on 4/16/25.
//

import UIKit
import SnapKit
import CoreData

class ViewController: UIViewController {

    // NSManagedObject를 담는 배열
    var phoneBookData = [PhoneBook]()

    private let label: UILabel = {
        let label = UILabel()
        label.text = "친구 목록"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 25)
        label.textAlignment = .center
        return label
    }()

    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(buttonTapped), for: .touchDown)
        return button
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.id)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    //MARK: view의 로드 직전마다 반영
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        setContainer()
        readAllData()
    }

    //MARK: UI를 view에 반영해주는 메서드
    private func configureUI() {
        view.backgroundColor = .white

        [label, addButton, tableView].forEach { view.addSubview($0) }

        label.snp.makeConstraints {
            $0.top.equalToSuperview().offset(80)
            $0.centerX.equalToSuperview()
        }

        addButton.snp.makeConstraints {
            $0.centerY.equalTo(label.snp.centerY)
            $0.trailing.equalToSuperview().offset(-30)
            $0.width.equalTo(50)
            $0.height.equalTo(30)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(50)
            $0.bottom.equalToSuperview().offset(-60)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerX.equalTo(label.snp.centerX)
        }
    }

    //MARK: "추가" 버튼 클릭 event
    @objc func buttonTapped() {
        navigationController?.pushViewController(PhoneBookViewController(), animated: false)
    }

}

//MARK: tableView 높이 설정(Delegate)
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
}

//MARK: tableView 설정, 셀 선택 시 event
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id) as? TableViewCell else {
            return UITableViewCell()
        }
        cell.configureCell(phoneBookData: phoneBookData[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        phoneBookData.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let secondView = PhoneBookViewController()
        // isEditiongBook에 데이터가 있으면 secondView에 데이터 반영
        secondView.isEditingBook = phoneBookData[indexPath.row]

        secondView.nameTextField.text = phoneBookData[indexPath.row].name
        secondView.phoneNumberTextField.text = phoneBookData[indexPath.row].phoneNumber

        if let imageData = phoneBookData[indexPath.row].image {
            secondView.profileImageView.image = UIImage(data: imageData)
        }

        navigationController?.pushViewController(secondView, animated: true)
    }
}

// MARK: container에 저장된 데이터 불러오는 메서드
extension ViewController {
    func readAllData() {
        do {
            guard let phoneBooks = try PhoneBookViewController.container?.viewContext.fetch(PhoneBook.fetchRequest()) else { return }
            // 불러오면서 이름을 기준으로 데이터 정렬
            phoneBookData = phoneBooks.sorted {
                return $0.name ?? "" < $1.name ?? ""
            }
            self.tableView.reloadData()
        } catch {
            print("데이터 읽기 실패")
        }
    }
}

// MARK: VC의 container를 세팅하는 메서드
extension ViewController {
    private func setContainer() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        PhoneBookViewController.container = appDelegate.persistentContainer
    }
}
