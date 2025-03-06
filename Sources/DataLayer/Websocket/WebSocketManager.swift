//
//  WebSocketManager.swift
//  DASwiftExtension
//
//  Created by TriBQ on 12/2/25.
//


import PusherSwift
import Foundation

public protocol WebsocketEvent {
    var key: String { get }
}

public protocol WebsocketChannel {
    var key: String { get }
}

public protocol WebsocketDelegate: AnyObject {
    func didReceive(event: WebsocketEvent, data: [String: Any])
}

public class WebSocketManager {
    private let endpoint: String
    private let path: String
    private let scheme: String
    private var cluster: String
    private var key: String

    public weak var delegate: WebsocketDelegate?
    private var pusher: Pusher?

    public init(
        scheme: String = "https",
        endpoint: String,
        path: String,
        key: String,
        cluster: String
    ) {
        self.endpoint = endpoint
        self.path = path
        self.scheme = scheme
        self.key = key
        self.cluster = cluster
    }

    public func clone() -> WebSocketManager {
        WebSocketManager(
            scheme: scheme,
            endpoint: endpoint,
            path: path,
            key: key,
            cluster: cluster
        )
    }

    public func createPusher() {
        let authBuilder = AuthRequestBuilder(endpoint: endpoint, path: self.path, scheme: self.scheme)

        let options = PusherClientOptions(
            authMethod: .authRequestBuilder(authRequestBuilder: authBuilder),
            host: .cluster(cluster)
        )

        pusher = Pusher(
            key: key,
            options: options
        )

        pusher?.connect()
        pusher?.delegate = self
    }

    public func destroyPusher() {
        pusher?.disconnect()
        pusher = nil
    }

    public func subscribe(to channel: String, events: WebsocketEvent...) {
        guard let pusher else { return }
        let myChannel = pusher.subscribe(channel)

        for event in events {
            let _ = myChannel.bind(
                eventName: event.key,
                eventCallback: { [weak self] (data: PusherEvent) -> Void in
                    guard let self = self else { return }
                    guard let jsonString = data.data else { return }
                    if let jsonData = jsonString.data(using: .utf8) {
                        do {
                            if let dictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                                self.delegate?.didReceive(event: event, data: dictionary)
                            }
                        } catch {
                            print("Error converting JSON: \(error)")
                        }
                    }

                }
            )
        }
    }

    public func disconnect() {
        guard let pusher else { return }

        pusher.disconnect()
    }

    public func unsubscribe(to channel: String) {
        guard let pusher else { return }

        pusher.unsubscribe(channel)
    }
}

extension WebSocketManager: PusherDelegate {
    public func changedConnectionState(from old: ConnectionState, to new: ConnectionState) {
        WSLogger.log("Connection state changed from \(old.stringValue()) to \(new.stringValue())")
    }

    public func debugLog(message: String) {
        WSLogger.log("Debug: \(message)")
    }

    public func subscribedToChannel(name: String) {
        WSLogger.log("Subscribed to channel: \(name)")
    }

    public func failedToSubscribeToChannel(name: String, response: URLResponse?, data: String?, error: NSError?) {
        var logMessage = "Failed to subscribe to channel: \(name)"
        if let response = response as? HTTPURLResponse {
            logMessage += "\nResponse Code: \(response.statusCode)"
        }
        if let data = data {
            logMessage += "\nResponse Data: \(data)"
        }
        if let error = error {
            logMessage += "\nError: \(error.localizedDescription)"
        }
        WSLogger.log(logMessage)
    }

    public func failedToDecryptEvent(eventName: String, channelName: String, data: String?) {
        WSLogger.log("Failed to decrypt event: \(eventName) on channel \(channelName). Data: \(data ?? "N/A")")
    }

    public func receivedError(error: PusherError) {
        WSLogger.log("Pusher Error: \(error.message)")
    }
}

public class AuthRequestBuilder: AuthRequestBuilderProtocol {
    public init(
        endpoint: String,
        path: String,
        scheme: String = "https"
    ) {
        self.endpoint = endpoint
        self.scheme = scheme
        self.path = path
    }
    
    private let endpoint: String
    private let path: String
    private let scheme: String

    public func requestFor(socketID: String, channelName: String) -> URLRequest? {
        var components: URLComponents?

        components = URLComponents()
        components?.scheme = scheme
        components?.host = endpoint
        components?.path = path

        guard let endpointURL = components?.url else {
            return nil
        }

        var request = URLRequest(url: endpointURL)
        request.httpMethod = "POST"

        let tmpHttpBody = "socket_id=\(socketID)&channel_name=\(channelName)".data(using: String.Encoding.utf8)
        request.httpBody = tmpHttpBody

        if let authToken = try? KeychainManager.shared.retrieveToken() {
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
}
