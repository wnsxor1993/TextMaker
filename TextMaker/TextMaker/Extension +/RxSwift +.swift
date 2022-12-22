//
//  RxSwift.swift
//  TextMaker
//
//  Created by Zeto on 2022/12/22.
//

import RxSwift

extension RxSwift.Reactive where Base: UIViewController {
    
    // viewWillAppear 시, rx 호출되는 기능 (Bool 타입 방출)
    public var viewWillAppear: Observable<Bool> {
        return methodInvoked(#selector(UIViewController.viewWillAppear))
            .map { $0.first as? Bool ?? false }
    }
}
