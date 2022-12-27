//
//  HomeCoordinator.swift
//  TextMaker
//
//  Created by Zeto on 2022/12/21.
//

import UIKit

final class HomeCoordinator: ParentCoordinator {
    
    weak var parentCoordinator: ParentCoordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(_ navigation: UINavigationController, with parent: ParentCoordinator) {
        self.navigationController = navigation
        self.parentCoordinator = parent
    }
    
    func start() {
        let mainVM = MainViewModel()
        let mainVC = MainViewController(mainVM, pushNavigateDelegate: self)
        
        self.navigationController.setViewControllers([mainVC], animated: false)
    }
    
    func remove(with childCoordinator: Coordinator) {
        guard let index = childCoordinators.firstIndex(where: { $0 === childCoordinator }) else { return }
        
        self.childCoordinators.remove(at: index)
    }
}

extension HomeCoordinator: PushNavigateDelegate {
    
    func push(_ model: TxtFileModel? = nil) {
        let coor: Coordinator = DetailCoordinator(self.navigationController, with: self, model: model)
        self.childCoordinators.append(coor)
        
        coor.start()
    }
}
