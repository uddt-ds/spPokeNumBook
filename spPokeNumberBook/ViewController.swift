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
        label.font = .boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        return label
    }()

    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.backgroundColor = .white
//        button.addTarget(self, action: <#T##Selector#>, for: <#T##UIControl.Event#>)
        return button
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    func configureUI() {
        view.backgroundColor = .white
        [label, addButton].forEach { view.addSubview($0) }

        label.snp.makeConstraints {
            $0.top.equalToSuperview().offset(70)
            $0.centerX.equalToSuperview()
        }

        addButton.snp.makeConstraints {
            $0.centerY.equalTo(label.snp.centerY)
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
}
