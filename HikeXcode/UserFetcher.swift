//
//  UserFetcher.swift
//  HikeXcode
//
//  Created by 今村翔一 on 2015/11/19.
//  Copyright © 2015年 今村翔一. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UserFetcher: UIViewController {
    
    static let baseURL = "http://localhost:3000/login/auth.json"
    static var defaultParameter:[String:String] = [:]
    static func download(callback:(User)->Void){
        Alamofire.request(.GET, baseURL, parameters: defaultParameter).responseJSON {_, _, result in
            if result.isSuccess,
                let res = result.value as? [String:AnyObject]{
                    print("userData:\(res)")
                    let userData = User(json: JSON(res))
                    callback(userData)
            }
        }
    }
}
