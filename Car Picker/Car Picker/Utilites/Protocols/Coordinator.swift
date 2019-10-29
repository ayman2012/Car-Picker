//
//  Coordinator.swift
//  Car Picker
//
//  Created by Ayman Fathy on 10/28/19.
//

import Foundation
import UIKit

protocol Coordinator {

    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}
