//
//  DetailViewController.swift
//  TextMaker
//
//  Created by Zeto on 2022/12/22.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import RxGesture

final class DetailViewController: UIViewController {
    
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
        $0.textColor = .black
    }
    
    private var titleField: UITextField = .init().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .lightGray
        $0.placeholder = "제목을 입력하세요"
    }
    
    private var contentText: UILabel = .init().then {
        $0.text = "내용"
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.textColor = .black
    }
    
    private var contentTextView: UITextView = .init().then {
        $0.text = "내용을 입력해주세요"
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .lightGray
        $0.backgroundColor = .white
    }
    
    private var saveButton: UIButton = .init().then {
        $0.setTitle("저장", for: .normal)
        $0.setTitleColor(.green, for: .normal)
        $0.layer.borderColor = UIColor.green.cgColor
        $0.layer.borderWidth = 1.5
        $0.isEnabled = false
    }
    
    weak var navigationDelegate: FormalNavigateDelegate?
    
    private var disposeBag: DisposeBag = .init()
    private let detailVM: DetailViewModel = .init()
    
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
        self.bindWithViewModel()
        self.bindInnerAction()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        self.configureCornerRound()
    }
}

private extension DetailViewController {
    
    func configureLayouts() {
        self.view.addSubviews(cancelButton, verticalStackView, contentTextView, saveButton)
        verticalStackView.addArrangedSubviews(titleText, titleField, contentText)
        
        cancelButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.width.equalTo(60)
            make.height.equalTo(40)
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.top.equalTo(cancelButton.snp.bottom).offset(15)
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
    
    func configureSaveButtonAttributes(with isEnabled: Bool) {
        if isEnabled {
            self.saveButton.backgroundColor = .green
            self.saveButton.layer.borderColor = UIColor.clear.cgColor
            self.saveButton.setTitleColor(.white, for: .normal)
            
        } else {
            self.saveButton.backgroundColor = .white
            self.saveButton.layer.borderColor = UIColor.green.cgColor
            self.saveButton.setTitleColor(.green, for: .normal)
        }
    }
    
    func bindWithViewModel() {
        let input = DetailViewModel.Input(titleDriver: titleField.rx.text.distinctUntilChanged().asDriver(onErrorJustReturn: nil),
                                          contextDriver: contentTextView.rx.text.distinctUntilChanged().asDriver(onErrorJustReturn: nil),
                                          saveButtonDriver: saveButton.rx.tap.asDriver())
        let output = detailVM.transform(with: input)
        
        output.buttonEnableRelay
            .distinctUntilChanged()
            .subscribe { [weak self] isEnabled in
                self?.saveButton.isEnabled = isEnabled
                self?.configureSaveButtonAttributes(with: isEnabled)
            }
            .disposed(by: disposeBag)
    }
    
    func bindInnerAction() {
        self.view.rx.tapGesture()
            .subscribe { [weak self] _ in
                self?.view.endEditing(true)
            }
            .disposed(by: disposeBag)
        
        self.cancelButton.rx.tap
            .asDriver { _ in return .never() }
            .drive { _ in
                self.navigationDelegate?.pop()
            }
            .disposed(by: disposeBag)
        
        self.contentTextView.rx.didBeginEditing
            .asDriver()
            .drive { _ in
                guard self.contentTextView.text == "내용을 입력해주세요" else { return }
                
                self.contentTextView.text = ""
            }
            .disposed(by: disposeBag)
    }
}
