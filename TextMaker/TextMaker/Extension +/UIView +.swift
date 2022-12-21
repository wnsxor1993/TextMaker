//
//  UIViewController +.swift
//  TextMaker
//
//  Created by Zeto on 2022/12/21.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        views.forEach {
            self.addSubview($0)
        }
    }
}
