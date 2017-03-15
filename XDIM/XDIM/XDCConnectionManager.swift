//
//  XDCConnectionManager.swift
//  XDIM
//
//  Created by 白大卫 on 17/3/3.
//  Copyright © 2017年 bdw. All rights reserved.
//

import Foundation

import CocoaAsyncSocket

enum ConnectionStatus {
    case connected
    case disconnected
}

class XDCConnectionManager: NSObject, GCDAsyncSocketDelegate
{
    var port: UInt16 = 80
    var host: String = "localhost"
    var socket: GCDAsyncSocket?
    var connectionStatus: ConnectionStatus?
    var reconnectCount: UInt16 = 0
    var reconnectTimer: Timer?
    
    var dataBuffer: Data?
    
    //单例
    static let sharedInstance: XDCConnectionManager = {
        let instance = XDCConnectionManager()
        instance.host = hostAdress
        instance.port = portNUM
        instance.socket = GCDAsyncSocket(delegate: instance, delegateQueue: DispatchQueue.main)
        instance.connectionStatus = .disconnected
        return instance
    }()
    private override init(){}
    
    func connect(){
        if let socket = self.socket{
            if (connectionStatus == .disconnected){
                do{
                    try socket.connect(toHost: host, onPort: port)
                    connectionStatus = .connected
                }catch{
                    XDCLog("connectERR")
                }
            }else{
                XDCLog("alreadyConnected")
            }
        }
    }
    
    func disconnect(){
        if let socket = self.socket{
            socket.disconnect()
            connectionStatus = .disconnected
            XDCLog("disconnected")
        }
        
    }
    
    func sendData(strMessage:String) {
        if let data : Data = strMessage.data(using: String.Encoding.utf8){
            if let aSocket = self.socket{
                aSocket.write(data, withTimeout: -1, tag: 0)
            }
            
        }else{
            XDCLog("invalid msg")
        }
    }
    func sendPackageData(packageData: Data){
        if let aSocket = self.socket{
            aSocket.write(packageData, withTimeout: -1, tag: 100)
        }
    
    }
    
    func receivePackageData(sock: GCDAsyncSocket) -> Data?{
        //self.socket?.read
        var tmpData: Data?
        
        sock.readData(to: <#T##Data#>, withTimeout: <#T##TimeInterval#>, buffer: <#T##NSMutableData?#>, bufferOffset: <#T##UInt#>, tag: <#T##Int#>)
        
        return tmpData
        
    }
    
    
    
    //socket?.writeData(msgTF.text?.dataUsingEncoding(NSUTF8StringEncoding), withTimeout: -1, tag: 0)
    
    // MARK: - GCDAsyncSocketDelegate

    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        XDCLog("connect succeed")
        //sock.readData(withTimeout: -1, tag: 0)
    }
    
    func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        XDCLog("send succeed")
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        //get data from server
        
        
        
        if let strReceived = String(data: data, encoding: .utf8){
            print(strReceived)
        }
        
        sock.readData(withTimeout: -1, tag: 0)
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        XDCLog("disconnected")
        XDCLog(err.debugDescription)
        
        if #available(iOS 10.0, *)
        {
            reconnectTimer = Timer.scheduledTimer(withTimeInterval: Double(reconnectCount) * 2.0, repeats: true, block: {(time) in
                self.reconnect()
            })
        }else{
            reconnectTimer = Timer.scheduledTimer(timeInterval: Double(reconnectCount) * 2.0, target: self, selector: #selector(self.reconnect), userInfo: nil, repeats: true);
        }
    }
    
    func reconnect(){
        self.reconnectCount += 1
        //重链接
        XDCLog("reconnect")
        self.connect()
    }
    
    func socketDidSecure(_ sock: GCDAsyncSocket) {
        
    }
}
