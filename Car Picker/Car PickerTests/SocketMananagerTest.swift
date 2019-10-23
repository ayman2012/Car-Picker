//
//  SocketMananagerTest.swift
//  Car PickerTests
//
//  Created by Ayman Fathy on 10/17/19.
//

import XCTest
@testable import Car_Picker

class SocketMananagerTest: XCTestCase {

    func test_startConnection() {
        XCTAssert(SocketMananager.shared.startConnection())
        SocketMananager.shared.stopConnection()
    }

    func test_stopConnection() {
        SocketMananager.shared.startConnection()
        XCTAssert(SocketMananager.shared.stopConnection())
    }

//        func test_websocketDidReceiveData() {
//            SocketMananager.shared.startConnection()
//            let expt = expectation(description: "expect response data")
//            SocketMananager.shared.completionWithData = { data in
//                XCTAssertNotNil(data)
//                expt.fulfill()
//            }
//            wait(for: [expt], timeout: 20)
//        }

    func test_websocketDidReceiveMessage() {

        let expt = expectation(description: "expect response message")

        SocketMananager.shared.startConnection()
        SocketMananager.shared.completionWithMessage = { data in
            expt.fulfill()
            XCTAssertNotNil(data)
        }
        wait(for: [expt], timeout: 20)
    }

//    func test_websocketDidDisconnect() {
//
//        let expt = expectation(description: "expect close data")
//
//        SocketMananager.shared.startConnection()
//        SocketMananager.shared.stopConnection()
//        SocketMananager.shared.disconnectcompletion = {
//            expt.fulfill()
//        }
//        wait(for: [expt], timeout: 20)
//    }

}
