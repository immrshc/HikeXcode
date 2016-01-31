//
//  ErrorHandling.swift
//  HikeXcode
//
//  Created by 今村翔一 on 2016/01/31.
//  Copyright © 2016年 今村翔一. All rights reserved.
//


class ErrorHandler {
    
    static func throwErrorForForgottenOverride() throws -> String {
        throw Errors.ForgottenOverride(whichClass: self.getClassName())

    
    //自身のクラス名を取得
    static private func getClassName() -> String {
        let className = NSStringFromClass(self)
        let range = className.rangeOfString(".")
        return className.substringFromIndex(range!.endIndex)
    }
    
    enum Errors: ErrorType {
        //オーバーライドされるべきスーパークラスのメソッドに記述する
        case ForgottenOverride(whichClass: String)
    }
    
}
