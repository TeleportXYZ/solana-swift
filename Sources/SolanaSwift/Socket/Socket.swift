import Foundation

class Socket: NSObject, SolanaSocket {
    // MARK: - Properties
    var isConnected: Bool = false
    var urlSession: URLSession!
    var task: URLSessionWebSocketTask!
    var wsHeartBeat: Timer!
    
    // MARK: - Streams
    let accountInfoStream = SocketResponseStream<SocketAccountResponse>()
    let signatureInfoStream = SocketResponseStream<SocketSignatureResponse>()
    
    // MARK: - Initializers
    init(endpoint: String) {
        
        self.urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        self.task = urlSession.webSocketTask(with: .init(string: endpoint)!)
        
        defer { connect() }
    }
    
    deinit {
        task.cancel(with: .goingAway, reason: nil)
        clean()
        accountInfoStream.onFinish?()
        signatureInfoStream.onFinish?()
    }
    
    // MARK: - Methods
    func connect() {
        clean()
        task.resume()
    }
    
    func disconnect() {
        unsubscribeToAllSubscriptions()
        isConnected = false
        task.cancel(with: .goingAway, reason: nil)
        clean()
    }
    
    func subscribe(account: String, isNative: Bool) {
        <#code#>
    }
    
    func unsubscribe(account: String) {
        <#code#>
    }
    
    func observeAllAccounts() -> SocketResponseStream<SocketAccountResponse> {
        <#code#>
    }
    
    func observe(account: String) -> SocketResponseStream<SocketAccountResponse> {
        <#code#>
    }
    
    func observe(signature: String) -> SocketResponseStream<SocketSignatureResponse> {
        <#code#>
    }
    
    // MARK: - Helpers
    /// Clean the environment
    private func clean() {
        wsHeartBeat?.invalidate()
        wsHeartBeat = nil
    }
    
    /// Request to get new message
    private func receiveNewMessage() async throws {
        do {
            let message = try await task.receive()
            switch message {
            case .string(_):
                // TODO: - Parse object
            case .data(_):
                break
            @unknown default:
                break
            }
            try await receiveNewMessage()
        } catch {
            accountInfoStream.onFailure?(error)
            signatureInfoStream.onFailure?(error)
            // TODO: - Handle error
        }
    }
    
    /// If your app is not sending messages over WebSocket with "acceptable" frequency, the server may drop your connection due to inactivity.
    /// Special ping-pong messages are used to solve this problem.
    private func ping() {
        task.sendPing { [weak self] error in
            if let error = error {
                print("Ping failed: \(error)")
            }
            self?.scheduleNextPing()
        }
    }
}

extension Socket: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        // wipe old subscriptions
        unsubscribeToAllSubscriptions()
        
        // set status
        status.accept(.connected)
        
        // set heart beat
        wsHeartBeat?.invalidate()
        wsHeartBeat = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] (_) in
            // Ping server every 5s to prevent idle timeouts
            self?.ping()
        }
        
        // resubscribe
        subscribeToAllAccounts()
        
        // mark as connected
        isConnected = true
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        
        clean()
        
        // mark as not connected
        isConnected = false
        
        // TODO: - Reopen?
    }
}
