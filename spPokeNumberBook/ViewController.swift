//
//  ViewController.swift
//  spPokeNumberBook
//
//  Created by Lee on 4/16/25.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    private let label: UILabel = {
        let label = UILabel()
        label.text = "친구 목록"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()

    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(buttonTapped), for: .touchDown)
        return button
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.id)
        return tableView
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }

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
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(50)
            $0.bottom.equalToSuperview().offset(-60)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerX.equalTo(label.snp.centerX)
        }
    }

    @objc func buttonTapped() {
        let secondView = PhoneBookViewController()
        navigationController?.pushViewController(secondView, animated: false)
    }

}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id) as? TableViewCell else {
            return UITableViewCell()
        }
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        7
    }

}
