//
//  BaseCoordinator.swift
//  WeClimb
//
//  Created by 윤대성 on 12/20/24.
//

import UIKit

protocol Coordinator: AnyObject {
    func start()
}

class BaseCoordinator: Coordinator {
    public var childCoordinators = [Coordinator]()
    
    /// 상위 계층에서 하위 코디네이터를 관리할 수 있도록 함
    weak var parentCoordinator: BaseCoordinator?
    
    /// 자식 코디네이터의 의존성을 추가하여 메모리에서 해제되지 않도록 함
    public func addDependency(_ coordinator: Coordinator) {
        for element in childCoordinators {
            if element === coordinator { return }
        }
        childCoordinators.append(coordinator)
    }
    
    /// 자식 코디네이터의 의존성을 제거하여 메모리에서 해제
    public func removeDependency(_ coordinator: Coordinator?) {
        guard childCoordinators.isEmpty == false, let coordinator = coordinator else { return }
        
        for (index, element) in childCoordinators.enumerated() {
            if element === coordinator {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    /// 자식코디네이터 제거
    public func childDidFinish(_ coordinator: Coordinator) {
        removeDependency(coordinator)
    }
    
    // MARK: - Coordinator
    func start() {
        
    }
}
