//
//  MainSectionModel.swift
//  TextMaker
//
//  Created by Zeto on 2022/12/21.
//

import RxDataSources

struct MainSectionModel {
    
    var header: String
    var items: [TxtFileModel]
}

extension MainSectionModel: AnimatableSectionModelType {
    
    typealias Item = TxtFileModel
    typealias Identity = String
    
    var identity: String {
        
        return header
    }
    
    init(original: MainSectionModel, items: [TxtFileModel]) {
        self = original
        self.items = items
    }
}
