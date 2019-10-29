//
//  SocketMananager.swift
//  Car Picker
//
//  Created by Ayman Fathy on 10/7/19.
//

import Foundation
import Starscream

class SocketMananager: WebSocketDelegate {


    static let shared = SocketMananager()
    private var socket: WebSocket?

    private init() {

        socket = WebSocket(url: URL(string: Constants.socketUrl)!)
        socket?.delegate = self
    }

    var completionWithMessage: ((VehicleStatusModel)->Void)?
    var completionWithData: ((VehicleStatusModel)->Void)?
    var disconnectcompletion: (()->())?

    @discardableResult
    func startConnection() -> Bool {

        guard let socket = socket else{ return false}
        socket.connect()
        return true
    }

    @discardableResult
    func stopConnection()-> Bool {

        guard let socket = socket else { return false}
        socket.disconnect()
        return !socket.isConnected
    }

    func websocketDidConnect(socket: WebSocketClient) {

    }

    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        disconnectcompletion?()
    }

    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        guard let jsonData = text.data(using: .utf8) else { return }
        guard let status = try? JSONDecoder().decode(VehicleStatusModel.self, from: jsonData) else{ return }
        completionWithMessage?(status)
    }

    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        guard let status = try? JSONDecoder().decode(VehicleStatusModel.self, from: data) else{ return }
        completionWithData?(status)
    }


}
