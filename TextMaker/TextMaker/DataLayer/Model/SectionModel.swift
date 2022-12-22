//
//  MainSectionModel.swift
//  TextMaker
//
//  Created by Zeto on 2022/12/21.
//

import RxDataSources

struct SectionModel {
    
    var header: String
    var items: [TxtFileModel]
}

extension SectionModel: AnimatableSectionModelType {
    
    typealias Item = TxtFileModel
    typealias Identity = String
    
    var identity: String {
        
        return header
    }
    
    init(original: SectionModel, items: [TxtFileModel]) {
        self = original
        self.items = items
    }
}
