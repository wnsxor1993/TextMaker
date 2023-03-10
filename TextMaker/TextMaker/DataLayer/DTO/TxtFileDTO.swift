//
//  TxtFileModel.swift
//  TextMaker
//
//  Created by Zeto on 2022/12/21.
//

import Foundation

struct TxtFileDTO {
    
    let fileUrl: URL
    let title: String
    let subText: String
}

extension TxtFileDTO: Equatable { }
