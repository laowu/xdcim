//
//  XDCLog.swift
//  XDIM
//
//  Created by 白大卫 on 17/3/6.
//  Copyright © 2017年 bdw. All rights reserved.
//

import Foundation


//封装的日志输出功能（T表示不指定日志信息参数类型）
func XDCLog<T>(_ message:T, file:String = #file, function:String = #function, line:Int = #line) {
    #if DEBUG
        //获取文件名
        let fileName = (file as NSString).lastPathComponent
        //打印日志内容
        print("\(fileName):\(line) \(function) | \(message)")
    #endif
}
