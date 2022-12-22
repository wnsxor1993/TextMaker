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
        $0.setTitleColor(.blue, for: .normal)
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
        $0.placeholder = "제목을 입력하세요"
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
        $0.setTitleColor(.green, for: .normal)
        $0.layer.borderColor = UIColor.green.cgColor
        $0.layer.borderWidth = 1.5
        $0.isEnabled = false
    }
    
    weak var navigationDelegate: FormalNavigateDelegate?
    
    init(naviagteDelegate: FormalNavigateDelegate) {
        self.navigationDelegate = naviagteDelegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Does not use this initializer")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.configureLayouts()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        self.configureCornerRound()
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
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.top.equalTo(backButton.snp.bottom).offset(15)
            make.height.equalToSuperview().multipliedBy(0.15)
        }
        
        titleText.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        
        titleField.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        
        contentText.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        
        contentTextView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.top.equalTo(verticalStackView.snp.bottom)
            make.height.equalToSuperview().multipliedBy(0.55)
        }
        
        saveButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-50)
            make.height.equalToSuperview().multipliedBy(0.07)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
    }
    
    func configureCornerRound() {
        saveButton.layer.cornerRadius = (saveButton.frame.height / 2)
    }
}
