//
//  XDCUtilCode.swift
//  XDIM
//
//  Created by 白大卫 on 17/3/13.
//  Copyright © 2017年 bdw. All rights reserved.
//

import Foundation

enum UtilCode{
    static let signup: UInt16 = 0x0101
    static let setup: UInt16 = 0x0102
    static let userUtil: UInt16 = 0x0103
    static let groupUtil: UInt16 = 0x0104
    static let messageUtil: UInt16 = 0x0105
}
enum SubUtilCodeForSignUp{
    static let verify: UInt16 = 0x0100
    static let signup: UInt16 = 0x0101
    static let login: UInt16 = 0x0200
    static let loginFeedback: UInt16 = 0x0201
    static let pwdForgotten: UInt16 = 0x0300
    static let pwdReset: UInt16 = 0x0301
    static let logout: UInt16 = 0x0400
    static let errExit: UInt16 = 0x0500
}
