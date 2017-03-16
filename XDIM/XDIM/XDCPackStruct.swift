//
//  XDCPackStruct.swift
//  XDIM
//
//  Created by 白大卫 on 17/3/13.
//  Copyright © 2017年 bdw. All rights reserved.
//

import Foundation

//12 bytes packageheader
struct PackageHeader {
    //协议版本号 1byte
    let versionCode: UInt8
    //加密方式协议状态
    let cryptType: UInt8
    //业务类型
    let packageID: UInt16
    //数据域长度
    let dataSegementLEN: UInt32
    //包序号
    let packageNUM: UInt32
}

//
struct DataHeader {
    let utilCode: UInt16
    let subUtilCode: UInt16
    let packageID: UInt32
}
