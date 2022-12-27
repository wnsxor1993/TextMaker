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
    private var model: TxtFileModel?
    
    init(_ navigation: UINavigationController, with parent: ParentCoordinator, model: TxtFileModel?) {
        self.navigationController = navigation
        self.parentCoordinator = parent
        self.model = model
    }
    
    func start() {
        if let model {
            let detailVM: DetailViewModel = .init(with: .old(model))
            let detailVC: DetailViewController = .init(with: detailVM, popNaviagteDelegate: self, viewCase: .old(model))
            
            self.navigationController.pushViewController(detailVC, animated: true)
            
        } else {
            let detailVM: DetailViewModel = .init()
            let detailVC: DetailViewController = .init(with: detailVM, popNaviagteDelegate: self)
            
            self.navigationController.pushViewController(detailVC, animated: true)
        }
    }
}

extension DetailCoordinator: PopNavigateDelegate {
    
    func pop() {
        self.navigationController.popViewController(animated: true)
        self.parentCoordinator?.remove(with: self)
    }
}
