//
//  DetailCoordinator.swift
//  TextMaker
//
//  Created by Zeto on 2022/12/22.
//

import UIKit

final class DetailCoordinator: Coordinator {
    
    weak var parentCoordinator: ParentCoordinator?
    var navigationController: UINavigationController
    
    init(_ navigation: UINavigationController, with parent: ParentCoordinator) {
        self.navigationController = navigation
        self.parentCoordinator = parent
    }
    
    func start() {
        let detailVC = DetailViewController(naviagteDelegate: self)
        
        self.navigationController.pushViewController(detailVC, animated: true)
    }
}

extension DetailCoordinator: FormalNavigateDelegate {
    
    func push() {
        
    }
    
    func pop() {
        self.navigationController.popViewController(animated: true)
        self.parentCoordinator?.remove(with: self)
    }
}
