//
//  SocketMananager.swift
//  Car Picker
//
//  Created by Ayman Fathy on 10/7/19.
//

import Foundation
import Starscream
import RxSwift
import RxCocoa

class SocketMananager {

    static let shared = SocketMananager()
    private var socket: WebSocket?

    private init() {
        guard let url = URL(string: Constants.socketUrl) else {
            return
        }
        socket = WebSocket(url: url)
    }

    func connect() -> Observable<VehicleStatusModel> {

       return Observable.create {  [weak self] observer in

        self?.socket?.onText = { text in
            guard let jsonData = text.data(using: .utf8) else { return }
            guard let status = try? JSONDecoder().decode(VehicleStatusModel.self, from: jsonData) else { return }
            observer.onNext(status)
        }

        self?.socket?.onData = { data in
            guard let vehicleStatus = try? JSONDecoder().decode(VehicleStatusModel.self, from: data) else { return }
            observer.onNext(vehicleStatus)
        }

        self?.socket?.onDisconnect = { error in
            observer.onError(error!)
        }
        self?.socket?.connect()
            return Disposables.create()
        }
    }
}
