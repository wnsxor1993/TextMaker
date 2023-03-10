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
        let saveFileEnableRelay: PublishRelay<Bool> = .init()
    }
    
    private let disposeBag: DisposeBag = .init()
    private let output: Output = .init()
    
    private let viewCase: DetailViewCase
    private let dataSourceManager = RxDataSourceManager.shared
    
    private var inputTitleText: String = ""
    private var inputContentText: String = ""
    
    init(with viewCase: DetailViewCase = .new) {
        self.viewCase = viewCase
    }
    
    func transform(with input: Input) -> Output {
        self.checkSaveButtonEnable(with: input)
        
        input.saveButtonDriver
            .drive { [weak self] _ in
                guard let self else { return }
                
                switch self.viewCase {
                case .new:
                    self.dataSourceManager.createFileData(title: self.inputTitleText, context: self.inputContentText)
                    
                case .old(let model):
                    self.dataSourceManager.modifyFileData(with: model, newTitle: self.inputTitleText, newContext: self.inputContentText)
                }
                
                self.output.saveFileEnableRelay.accept(true)
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
                let contextBool = (context != "") && (context != "????????? ??????????????????")
                
                return (titleBool && contextBool)
            }
            .asDriver(onErrorJustReturn: false)
            .drive { [weak self] isEnabled in
                self?.output.buttonEnableRelay.accept(isEnabled)
            }
            .disposed(by: disposeBag)
    }
}
