//
//  SocketMananager.swift
//  Car Picker
//
//  Created by Ayman Fathy on 10/7/19.
//

import Foundation
import Starscream

class SocketMananager: WebSocketDelegate {


    private var socket: WebSocket?

    static let shared = SocketMananager()

    private init() {
        socket = WebSocket(url: URL(string: Constants.socketUrl)!)
        socket?.delegate = self
    }


    var completionWithMessage: ((String)->Void)?
    var completionWithData: ((Data)->Void)?
    var disconnectcompletion: (()->())?
    @discardableResult
    func startConnection() -> Bool {
        guard let socket = socket else{ return false}
        socket.connect()
        return true
    }
    @discardableResult
    func stopConnection()-> Bool {
        guard let socket = socket else{ return false}
        socket.disconnect()
        return true
    }

    func websocketDidConnect(socket: WebSocketClient) {

    }

    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        disconnectcompletion?()
    }

    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        completionWithMessage?(text)
    }

    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        completionWithData?(data)
    }

}
