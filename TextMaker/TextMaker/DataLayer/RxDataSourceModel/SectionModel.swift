//
//  MainSectionModel.swift
//  TextMaker
//
//  Created by Zeto on 2022/12/21.
//

import RxDataSources

struct SectionModel {
    
    var header: String
    var items: [CellModel]
}

extension SectionModel: AnimatableSectionModelType {
    
    typealias Item = CellModel
    typealias Identity = String
    
    var identity: String {
        
        return header
    }
    
    init(original: SectionModel, items: [CellModel]) {
        self = original
        self.items = items
    }
}
