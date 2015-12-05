//
//  LoginController.swift
//  HikeXcode
//
//  Created by 今村翔一 on 2015/11/19.
//  Copyright © 2015年 今村翔一. All rights reserved.
//

import UIKit

class LoginController: UIViewController, UITextFieldDelegate {
    /*
    
    user_1:
    id: 1
    username: ShoichiImamura
    mail: syoichiimamura@gmail.com
    password: ybrdgaw8
    
    user_2:
    id: 2
    username: Shoichi
    mail: s1210259@u.tsukuba.ac.jp
    password: 1106Shoichi
    
    user_3:
    id: 3
    username: Imamura
    mail: syoichiimamura@yahoo.com
    password: 1106Imamura
    
    */

    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var passWordTF: UITextField!
    @IBAction func tapLoginBtn(sender: AnyObject) {
        
        if let username:String = userNameTF.text,
            let password:String = passWordTF.text {
                UserFetcher.defaultParameter = ["username":username, "password":password]
                UserFetcher.download{ (userData) -> Void in
                    //AppDelegateで共有させる
                    //本来はメモリではなく、ストレージに保存させるが、テストのため
                    let app = UIApplication.sharedApplication().delegate as! AppDelegate
                    app.sharedUserData = ["id":userData.id, "username":userData.username]
                    //app.sharedUserData = ["id":userData.id, "username":userData.username, "userIcon":userData.userIcon]
                    //画面遷移する
                    if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("TopTabBarCtrl")
                        as? TopTabBarController {
                            self.presentViewController(vc, animated: true, completion: nil)
                    }
                }
                
        }
        //elseの場合は注意の通知を表示する
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userNameTF.delegate = self
        self.passWordTF.delegate = self
        //パスワードが隠せるようにする
        self.passWordTF.secureTextEntry = true
    }
    
    //returnキーが押された時にキーボードを閉じる
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}