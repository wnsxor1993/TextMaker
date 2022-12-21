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

extension MainSectionModel: SectionModelType {
    
    typealias Item = TxtFileModel
    
    init(original: MainSectionModel, items: [TxtFileModel]) {
        self = original
        self.items = items
    }
}
