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

    func test_websocketDidReceiveMessage() {

        let exptResponse = expectation(description: "expect response message")

        SocketMananager.shared.startConnection()
        SocketMananager.shared.completionWithMessage = { message in
            XCTAssertNotNil(message)
             exptResponse.fulfill()
            SocketMananager.shared.stopConnection()
            SocketMananager.shared.completionWithMessage = nil
        }
        wait(for: [exptResponse], timeout: 10)
    }

//    func test_websocketDidDisconnect() {
//
//        let expt = expectation(description: "expect close connection")
//        SocketMananager.shared.completionWithMessage = nil
//
//        SocketMananager.shared.startConnection()
//        SocketMananager.shared.disconnectcompletion = {
//            expt.fulfill()
//        }
//        SocketMananager.shared.stopConnection()
//
//        wait(for: [expt], timeout: 10)
//    }

}
