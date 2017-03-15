//
//  XDCPackageManager.swift
//  XDIM
//
//  Created by 白大卫 on 17/3/14.
//  Copyright © 2017年 bdw. All rights reserved.
//

import Foundation


class XDCPackageManager{
    static let sharedInstance:XDCPackageManager = {
        let instance = XDCPackageManager()
        
        return instance
    
    }()

    //将包头参数和包数据contentData拼接为完整包packageData
    func packData(utilCode: UInt16, subUtilCode: UInt16, packageID: UInt32, contentData: Data, dataLength: UInt32) -> Data{
        var packageHeader: PackageHeader = PackageHeader(utilCode: utilCode, subUtilCode: subUtilCode, packageID: packageID)
        var packageData: Data = Data(bytes: &packageHeader, count: MemoryLayout<PackageHeader>.size)
        packageData.append(contentData)
        return packageData
    }
    //从返回包中获取包数据段
    func unpackData(package: Data) -> Data? {
        
        var pacakgeData: Data?
        
        if (package.count > MemoryLayout<PackageHeader>.size){
            pacakgeData = package.subdata(in: MemoryLayout<PackageHeader>.size..<package.count)
        }
        return pacakgeData
    }
    
    
}
