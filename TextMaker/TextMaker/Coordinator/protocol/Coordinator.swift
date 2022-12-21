//
//  Coordinator.swift
//  TextMaker
//
//  Created by Zeto on 2022/12/21.
//

import UIKit

protocol Coordinator: AnyObject {
    
    var parentCoordinator: ParentCoordinator? { get }
    var navigationController: UINavigationController { get set }
    
    func start()
}
