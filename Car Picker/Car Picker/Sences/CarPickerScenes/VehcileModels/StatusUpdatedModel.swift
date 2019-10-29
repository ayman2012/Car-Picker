//
//  StatusUpdatedModel.swift
//  Car Picker
//
//  Created by Ayman Fathy on 10/28/19.
//

import Foundation

// MARK: - StatusUpdated
struct StatusUpdatedModel: Codable {
    let status: String
    init(status: String) {
        self.status = status
    }
}
