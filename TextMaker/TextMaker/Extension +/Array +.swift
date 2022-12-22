//
//  Array +.swift
//  TextMaker
//
//  Created by Zeto on 2022/12/22.
//

import Foundation

extension Array {
    
    // 잘못된 배열 index 접근으로 인한 fatalError 방지
    subscript (safe index: Int) -> Element? {
        
        return indices.contains(index) ? self[index] : nil
    }
}
