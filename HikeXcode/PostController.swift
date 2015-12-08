//
//  PostController.swift
//  HikeXcode
//
//  Created by 今村翔一 on 2015/12/02.
//  Copyright © 2015年 今村翔一. All rights reserved.
//

import UIKit

class PostController: UIViewController, UITabBarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imageURL:String = "postBackImage01.jpg"
    var latitude: Double?
    var longitude: Double?

    @IBOutlet weak var postBackIV: UIImageView!
    @IBOutlet weak var postShowTV: UITextView!
    @IBOutlet weak var selectImageTB: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectImageTB.delegate = self
        
        postBackIV.image = UIImage(named:"postBackImage01.jpg")

        print("画像のファイル名：\(NSString(string: "postBackImage01.jpg").stringByDeletingPathExtension)")
        print("画像の拡張子：\(NSString(string: "postBackImage01.jpg").pathExtension)")

        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        if let latitude = app.sharedUserData["latitude"] as? Double,
            let longitude = app.sharedUserData["longitude"] as? Double {
                self.latitude = latitude
                self.longitude = longitude
                print("ユーザの投稿時の緯度経度：\(latitude), \(longitude)")
        }
        //PostクラスでlocationManagerが実行できるかのテスト
        //Post(content: "", imageURL: "", latitude: 0, longitude: 0).locationUpdate()
        //Postでは出来なくて、PostControllerでは出来るのはなぜか質問する
    }
    
    //押されたタブをタグで識別して処理を分ける
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        switch item.tag {
            case 0:
                print(item.tag)
                postBackIV.image = UIImage(named:"postBackImage06.jpg")
                self.imageURL = "postBackImage06.jpg"
            case 1:
                print(item.tag)
                //カメラロールへアクセス
                self.pickImageFromLibrary()
            default:
                print(item.tag)
        }
    }
    
    //ライブラリから写真を選択する
    func pickImageFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    //写真を選択した時に呼ばれる
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.postBackIV.image = image
            }
            
            if let assetURL:AnyObject = info[UIImagePickerControllerReferenceURL] {
                print(String(assetURL))
                //このURLを取り出すにはAssetLibrary.Frameworkが必要になる
            }
            picker.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func cancelPost(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func doPost(sender: AnyObject) {
        if let text:String = self.postShowTV.text,
            //Xcode内の画像のURLを引き渡す
            //画像がカメラロールから選ばれた場合は、AssetLibrary.Frameworkでカメラロールへのパスを取得してimageURLに格納する
            let imageURL:String = self.imageURL,
            let latitude:Double = self.latitude,
            let longitude:Double = self.longitude {
                let post = Post(content: text, imageURL: imageURL, latitude: latitude, longitude: longitude)
                //投稿されない場合はシミュレータが位置情報を取れていない場合を疑う
                
                //画像以外はリクエストできる
                let postWithouotImage = PostDispatcher(post: post)
                postWithouotImage.download{(result) -> Void in
                    if result {
                        print("テキストの投稿が完了しました")
                        //選択された画像をインスタンスにセットする
                        //postWithouotImage.postBackIV = ????
                        //画像のアップロードと投稿情報のリクエストをする
                        postWithouotImage.upload {(result) -> Void in
                            if result {
                                print("画像の投稿が完了しました")
                            } else {
                                print("画像の投稿が失敗しました")
                            }
                        }
                    } else {
                        print("テキストの投稿が失敗しました")
                    }
                }
        }
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
}
