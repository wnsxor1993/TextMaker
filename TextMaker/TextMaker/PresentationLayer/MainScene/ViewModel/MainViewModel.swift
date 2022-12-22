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
        let tapPlusButton: Driver<Void>
    }
    
    struct Output {
        let collectionSectionModels: PublishRelay<[MainSectionModel]> = .init()
    }
    
    private let disposeBag = DisposeBag()
    private let output = Output()
    
    private var temporaryInt = 1
    private var originMainSections: MainSectionModel = .init(header: "First", items: [])
    private var originMainItems: [TxtFileModel] = []
    
    func transform(with input: Input) -> Output {
        input.tapPlusButton
            .drive { [weak self] _ in
                guard let self, let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
                
//                let fileURL = documentURL.appendingPathComponent("new\(self.temporaryInt).txt")
                let titleText = "new\(self.temporaryInt)"
                let context = "This is dummy data"
                
                let item = TxtFileModel(fileUrl: documentURL, title: titleText, subText: context)
                self.originMainItems.append(item)
                
                let section = MainSectionModel(original: self.originMainSections, items: self.originMainItems)
                self.originMainSections = section
                self.output.collectionSectionModels.accept([section])
                
                self.temporaryInt += 1
            }
            .disposed(by: disposeBag)
        
        return output
    }
    
    func removeCell(with indexPath: [IndexPath]) {
        guard let row = indexPath.first?.row, let _ = originMainItems[safe: row] else { return }
        
        self.originMainItems.remove(at: row)
        
        let section = MainSectionModel(original: self.originMainSections, items: self.originMainItems)
        self.originMainSections = section
        self.output.collectionSectionModels.accept([section])
    }
}
