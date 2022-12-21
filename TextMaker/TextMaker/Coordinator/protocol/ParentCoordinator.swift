//
//  ParentCoordinator.swift
//  TextMaker
//
//  Created by Zeto on 2022/12/21.
//

import UIKit

protocol ParentCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] { get set }
    
    // MARK: 미사용 시, 인스턴스 해제를 통해 성능 향상
    func remove(with childCoordinator: Coordinator)
}
