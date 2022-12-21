//
//  TxtFileModel.swift
//  TextMaker
//
//  Created by Zeto on 2022/12/21.
//

import RxDataSources

struct TxtFileModel {
    
    let fileUrl: URL
    let title: String
    let subText: String
}

extension TxtFileModel: IdentifiableType, Equatable {
    
    typealias Identity = String
    
    var identity: String {
        
        return title
    }
}
