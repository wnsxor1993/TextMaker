//
//  DetailViewModel.swift
//  TextMaker
//
//  Created by Zeto on 2022/12/22.
//

import RxSwift
import RxCocoa

final class DetailViewModel {
    
    struct Input {
        let titleDriver: Driver<String?>
        let contextDriver: Driver<String?>
        let saveButtonDriver: Driver<Void>
    }
    
    struct Output {
        let buttonEnableRelay: PublishRelay<Bool> = .init()
    }
    
    private let disposeBag: DisposeBag = .init()
    private let output: Output = .init()
    
    private let dataSourceManager = RxDataSourceManager.shared
    
    private var inputTitleText: String = ""
    private var inputContentText: String = ""
    
    func transform(with input: Input) -> Output {
        self.checkSaveButtonEnable(with: input)
        
        input.saveButtonDriver
            .drive { [weak self] _ in
                guard let self else { return }
                
                self.dataSourceManager.createFileData(title: self.inputTitleText, context: self.inputContentText)
            }
            .disposed(by: disposeBag)
        
        return output
    }
}

private extension DetailViewModel {
    
    func checkSaveButtonEnable(with input: Input) {
        let titleObservable = input.titleDriver.asObservable()
        let contextObservable = input.contextDriver.asObservable()
        
        Observable
            .combineLatest(titleObservable, contextObservable)
            .map { [weak self] (title, context) -> Bool in
                guard let title, let context else { return false }
                
                self?.inputTitleText = title
                self?.inputContentText = context
                
                let titleBool = (title != "")
                let contextBool = (context != "") && (context != "내용을 입력해주세요")
                
                return (titleBool && contextBool)
            }
            .asDriver(onErrorJustReturn: false)
            .drive { [weak self] isEnabled in
                self?.output.buttonEnableRelay.accept(isEnabled)
            }
            .disposed(by: disposeBag)
    }
}
