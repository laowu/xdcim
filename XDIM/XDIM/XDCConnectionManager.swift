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

enum PackageSegementTag: Int{
    case header = 100
    case payload = 200

}

class XDCConnectionManager: NSObject, GCDAsyncSocketDelegate
{
    var port: UInt16 = 80
    var host: String = "localhost"
    var socket: GCDAsyncSocket?
    var connectionStatus: ConnectionStatus?
    var reconnectCount: UInt16 = 0
    var reconnectTimer: Timer?
    
    var packageBuffer: NSMutableData?
    var headerBuffer: Data?
    var dataSegementLEN: UInt = 0
    
    
    
    
    
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

    // MARK: - managePackageData
    //获取包头 转入didread
    func getPackageHeader(socket: GCDAsyncSocket){
        socket.readData(toLength: headerLEN, withTimeout: -1, buffer: packageBuffer, bufferOffset: 0, tag: PackageSegementTag.header.rawValue)
    }
    //解析包头
    //read to length
    func resolvePackageHeader(packageHeaderData: Data) -> PackageHeader? {
        var packageHeader: PackageHeader?
        if (packageHeaderData.count == Int(headerLEN)){
        
            let versionCode: UInt8 = packageHeaderData.withUnsafeBytes{$0.pointee}
            let cryptType: UInt8 = packageHeaderData.withUnsafeBytes{($0+1).pointee}
            let packageID: UInt16 = packageHeaderData.withUnsafeBytes{($0+1).pointee}
            let dataSegementLEN: UInt32 = packageHeaderData.withUnsafeBytes{($0+1).pointee}
            let packageNUM: UInt32 = packageHeaderData.withUnsafeBytes{($0+2).pointee}
            packageHeader = PackageHeader(versionCode: versionCode, cryptType: cryptType, packageID: packageID, dataSegementLEN: dataSegementLEN, packageNUM: packageNUM)
        }else{
            XDCLog("packageHeaderData ERR")
        }
        return packageHeader
    }
    
    //根据包头中数据长度接收完整包
    func getPackagePayload(socket: GCDAsyncSocket){
        let packageFullLength = dataSegementLEN + verificationLEN
        if let buffer = self.packageBuffer{
            let bufferOffset = UInt(buffer.length)
            socket.readData(toLength: UInt(packageFullLength), withTimeout: -1, buffer: buffer, bufferOffset: bufferOffset, tag: PackageSegementTag.payload.rawValue)
        }
    }
    
    //解析数据头部 dataHeader
    func resolveDataHeader(payloadData: Data) -> DataHeader? {
        var dataHeader: DataHeader?
        if(payloadData.count > Int(headerLEN))
        {
            let utilCode: UInt16 = payloadData.withUnsafeBytes{$0.pointee}
            let subUtilCode: UInt16 = payloadData.withUnsafeBytes{($0+1).pointee}
            let packageID: UInt32 = payloadData.withUnsafeBytes{($0+1).pointee}
        
            dataHeader = DataHeader(utilCode: utilCode, subUtilCode: subUtilCode, packageID: packageID)
            
        }else{
            XDCLog("payloadData ERR")
        }
        return dataHeader
    }
    //解析 dataHeader dataHeader data
    func resolvePackagePayload(packagePayload: Data, dataHeader: inout DataHeader?, dataContent: inout Data?){
        
        let rangeFrom = Int(headerLEN)
        let rangeTo = Int(headerLEN + self.dataSegementLEN)
        //dataHeader + dataContent
        let data = packagePayload.subdata(in: rangeFrom..<rangeTo)
        
        dataHeader = resolveDataHeader(payloadData: data)
        dataContent = data.subdata(in: 12..<data.count)
    
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
        
        switch tag {
        case PackageSegementTag.header.rawValue:
            //接收数据为包头
            if let packageHeader = resolvePackageHeader(packageHeaderData: data){
                print("get header")
                self.dataSegementLEN = UInt(packageHeader.dataSegementLEN)
                
                //继续接收数据部分
                getPackagePayload(socket: sock)
            }else{
                XDCLog("resolvePackageHeader ERR")
            }
            
        case PackageSegementTag.payload.rawValue:
            //接收数据为包内容
            //数据部分头部
            var dataHeader: DataHeader?
            //数据部分内容
            var dataContent: Data?
            resolvePackagePayload(packagePayload: data, dataHeader: &dataHeader, dataContent: &dataContent)
            
        default:
            if let strReceived = String(data: data, encoding: .utf8){
                XDCLog("readDataDefault")
                print(strReceived)
            }else{
                XDCLog("readData ERR")
            }
        }
        

        
        //sock.readData(withTimeout: -1, tag: 0)
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
