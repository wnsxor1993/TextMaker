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
    private var txtFileModel: TxtFileModel?
    
    init(_ navigation: UINavigationController, with parent: ParentCoordinator, model: TxtFileModel?) {
        self.navigationController = navigation
        self.parentCoordinator = parent
        self.txtFileModel = model
    }
    
    func start() {
        let detailVC = DetailViewController(popNaviagteDelegate: self)
        
        if let txtFileModel {
            detailVC.setProperties(with: txtFileModel)
        }
        
        self.navigationController.pushViewController(detailVC, animated: true)
    }
}

extension DetailCoordinator: PopNavigateDelegate {
    
    func pop() {
        self.navigationController.popViewController(animated: true)
        self.parentCoordinator?.remove(with: self)
    }
}
