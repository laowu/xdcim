//
//  XDCDataManager.swift
//  XDIM
//
//  Created by 白大卫 on 17/3/9.
//  Copyright © 2017年 bdw. All rights reserved.
//


//接收数据并并生成类实例
//持久化？
//


import Foundation
import SwiftyJSON

class XDCDataManager: NSObject{
    
    var objData: NSObject?
    
    static let sharedInstance: XDCDataManager = {
    
        var instance = XDCDataManager()
        return instance
    }()
    
    func getUserEntity(objData: Data)->XDCUser{
    
        let json = JSON(objData)
        let strUserName: String? = json["name"].string
        let strSex: String? = json["sex"].string
        let strAge: String? = json["age"].string
        let strEmail: String? = json["email"].string
        let strTel: String? = json["tel"].string
        
        let user: XDCUser = XDCUser(strUserName: strUserName, strSex: strSex, strAge: strAge, strEmail: strEmail, strTel: strTel)
        return user
    }
    
    
    //接收服务器数据包获取数据
    //func
    
    
    
}

