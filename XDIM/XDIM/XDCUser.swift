//
//  XDCUser.swift
//  XDIM
//
//  Created by 白大卫 on 17/3/9.
//  Copyright © 2017年 bdw. All rights reserved.
//

import Foundation

enum Sex{
    case male
    case female
}

class XDCUser : NSObject{
    var strUserID: String? = "xx_xxxx"
    var strUsername: String? = "whoImI"
    
    var enmSex: Sex? = .male
    var intAge: Int? = 99
    
    var strEmail: String? = "xxx@gmail.com"
    var strTel: String? = "13786868686"
    
    
    init(strUserName: String?, strSex: String?, strAge: String?, strEmail: String?, strTel: String?){
        super.init()
        
        let mailPattern: String = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
        let telPattern: String = "^1(3[0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}$"
        
        
        if let userName = strUsername{
            self.strUsername = userName
        }
        if let sex = strSex{
            if (sex == "male"){
                self.enmSex = .male
            }else if(sex == "female"){
                self.enmSex = .female
            }
        }
        if let age = strAge{
            if let intAge = Int(age){
                if 1 ... 99 ~= intAge{
                    self.intAge = intAge
                }
            }
        }
        if let email = strEmail{
            let matcher = XDCRegex(pattern: mailPattern)
            if matcher.match(input: email){
                self.strEmail = email
            }
        }
        if let tel = strTel{
            
            let matcher = XDCRegex(pattern: telPattern)
            if matcher.match(input: tel) {
                self.strTel = tel
            }
        }
    }
}
