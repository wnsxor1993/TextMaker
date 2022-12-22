//
//  UIStackView +.swift
//  TextMaker
//
//  Created by Zeto on 2022/12/22.
//

import UIKit

extension UIStackView {
    
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach {
            self.addArrangedSubview($0)
        }
    }
}
