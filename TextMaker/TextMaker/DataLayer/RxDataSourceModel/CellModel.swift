//
//  CellModel.swift
//  TextMaker
//
//  Created by Zeto on 2023/01/02.
//

import RxDataSources

enum CellModel {
    
    case textFile(TxtFileDTO)
}

extension CellModel: IdentifiableType, Equatable {
    
    typealias Identity = String
    
    var identity: String {
        switch self {
        case .textFile(_):
            return "TxtCellModel"
        }
    }
}
