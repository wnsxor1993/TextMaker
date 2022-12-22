//
//  MainViewModel.swift
//  TextMaker
//
//  Created by Zeto on 2022/12/21.
//

import RxSwift
import RxCocoa

final class MainViewModel {
    
    struct Input {
        let viewWillAppearDriver: Driver<Bool>
    }
    
    struct Output {
        let collectionSectionModels: PublishRelay<[SectionModel]> = .init()
    }
    
    private let disposeBag: DisposeBag = .init()
    private let output: Output = .init()
    
    private let dataSourceManager = RxDataSourceManager.shared
    
    func transform(with input: Input) -> Output {
        input.viewWillAppearDriver
            .drive { [weak self] isWillAppear in
                guard let self, isWillAppear else { return }
                
                self.output.collectionSectionModels.accept(self.dataSourceManager.fetchSectionModels())
            }
            .disposed(by: disposeBag)
        
        return output
    }
    
    func removeCell(with indexPath: [IndexPath]) {
        defer {
            self.output.collectionSectionModels.accept(self.dataSourceManager.fetchSectionModels())
        }
        
        self.dataSourceManager.removeFileData(with: indexPath)
    }
}
