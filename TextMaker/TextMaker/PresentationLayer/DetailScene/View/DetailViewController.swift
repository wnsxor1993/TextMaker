//
//  DetailViewController.swift
//  TextMaker
//
//  Created by Zeto on 2022/12/22.
//

import UIKit
import SnapKit
import Then

final class DetailViewController: UIViewController {
    
    private var backButton: UIButton = .init().then {
        $0.setTitle("이전", for: .normal)
    }
    
    private var cancelButton: UIButton = .init().then {
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(.red, for: .normal)
    }
    
    private var verticalStackView: UIStackView = .init().then {
        $0.distribution = .fillEqually
        $0.axis = .vertical
        $0.alignment = .leading
    }
    
    private var titleText: UILabel = .init().then {
        $0.text = "제목"
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
    }
    
    private var titleField: UITextField = .init().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .lightGray
    }
    
    private var contentText: UILabel = .init().then {
        $0.text = "내용"
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
    }
    
    private var contentTextView: UITextView = .init().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .lightGray
    }
    
    private var saveButton: UIButton = .init().then {
        $0.setTitle("저장", for: .normal)
        $0.setTitleColor(.darkGray, for: .normal)
        $0.layer.borderColor = UIColor.green.cgColor
        $0.layer.borderWidth = 1.5
        $0.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        configureCornerRound()
    }
}

private extension DetailViewController {
    
    func configureLayouts() {
        self.view.addSubviews(backButton, cancelButton, verticalStackView, contentTextView, saveButton)
        verticalStackView.addArrangedSubviews(titleText, titleField, contentText)
        
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.width.equalTo(60)
            make.height.equalTo(40)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalTo(backButton)
            make.width.height.equalTo(backButton)
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(backButton.snp.bottom).offset(15)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(verticalStackView.snp.bottom)
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        
        saveButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalToSuperview().multipliedBy(0.15)
            make.width.equalToSuperview().multipliedBy(0.3)
        }
    }
    
    func configureCornerRound() {
        saveButton.layer.cornerRadius = (saveButton.frame.height / 2)
    }
}
