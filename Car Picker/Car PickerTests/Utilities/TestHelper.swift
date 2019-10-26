//
//  Helper.swift
//  Car PickerTests
//
//  Created by Ayman Fathy on 10/24/19.
//

import Foundation

public class TestHelper {
    /**
     get data from static jsons
     - Parameter name: file name
     - Parameter extension: file extension
     */
    func loadStubDataFromBundle(name: String, extension: String) -> Data? {
        let bundle = Bundle(for: type(of: self))
        let url = bundle.url(forResource: name, withExtension: `extension`)
        return try? Data(contentsOf: url!)
    }
}
