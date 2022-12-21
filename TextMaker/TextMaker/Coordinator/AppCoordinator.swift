//
//  AppCoordinator.swift
//  TextMaker
//
//  Created by Zeto on 2022/12/21.
//

import UIKit

final class AppCoordinator: ParentCoordinator {
    
    weak var parentCoordinator: ParentCoordinator? = nil
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(_ navigation: UINavigationController) {
        self.navigationController = navigation
    }
    
    func start() {
        let homeCoor = HomeCoordinator(navigationController, with: self)
        
        self.childCoordinators.append(homeCoor)
        homeCoor.start()
    }
    
    func remove(with childCoordinator: Coordinator) {
        // MARK: Not use (메인 화면 하나라 전환 요소가 없음)
        fatalError("No element which can convert View")
    }
}
