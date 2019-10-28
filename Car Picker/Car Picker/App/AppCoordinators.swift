//
//  AppCoordinators.swift
//  Car Picker
//
//  Created by Ayman Fathy on 10/28/19.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = CarPickerViewController.instantiate(storyboardName: "Main")
        let carPickerViewModel = CarPickerViewModel()
        vc.setupViewModel(viewModel: carPickerViewModel)
        navigationController.pushViewController(vc, animated: false)
    }
}
