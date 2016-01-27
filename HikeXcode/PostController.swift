//
//  PostController.swift
//  HikeXcode
//
//  Created by 今村翔一 on 2015/12/02.
//  Copyright © 2015年 今村翔一. All rights reserved.
//

import UIKit

class PostController: UIViewController, UITabBarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var imageURL:String = "Image01.jpg"
    private var latitude: Double?
    private var longitude: Double?
    
    //投稿画面の背景画像
    @IBOutlet weak var postBackIV: UIImageView!
    //投稿内容のテキスト
    @IBOutlet weak var postShowTV: UITextView!
    //投稿画面の画像選択用のタブ
    @IBOutlet weak var selectImageTB: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectImageTB.delegate = self
        
        postBackIV.image = UIImage(named:"Image01.jpg")

        print("画像のファイル名：\(NSString(string: "Image01.jpg").stringByDeletingPathExtension)")
        print("画像の拡張子：\(NSString(string: "Image01.jpg").pathExtension)")
        
        //取得した位置情報を設定する
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        if let latitude = app.sharedUserData["latitude"] as? Double,
            let longitude = app.sharedUserData["longitude"] as? Double {
                self.latitude = latitude
                self.longitude = longitude
                print("ユーザの投稿時の緯度経度：\(latitude), \(longitude)")
        }

    }
    
    //押されたタブをタグで識別して処理を分ける
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        switch item.tag {
            case 0:
                postBackIV.image = UIImage(named:"Image06.jpg")
                self.imageURL = "Image06.jpg"
            case 1:
                //カメラロールへアクセス
                self.pickImageFromLibrary()
            default:
                print("item.tag:\(item.tag)")
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
            //背景に画像を設定する
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
    
    //元の画面に戻る
    @IBAction func cancelPost(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //投稿ボタンの処理
    @IBAction func doPost(sender: AnyObject) {
        if let text:String = self.postShowTV.text,
            //Xcode内の画像のURLを引き渡す
            //画像がカメラロールから選ばれた場合は、AssetLibrary.Frameworkでカメラロールへのパスを取得してimageURLに格納する
            let imageURL:String = self.imageURL,
            let latitude:Double = self.latitude,
            let longitude:Double = self.longitude {
                let post = PostWrapper.getInstance(["Content": text, "ImageURL": imageURL, "Latitude": latitude, "Longitude": longitude])
                //投稿されない場合はシミュレータが位置情報を取れていない場合を疑う
                
                //画像以外をリクエストする
                let postWithouotImage = PostDispatcher(post: post)
                postWithouotImage.download{(result) -> Void in
                    if result {
                        print("テキストの投稿が完了しました")
                        //選択された画像をインスタンスにセットする
                        //postWithouotImage.postBackIV = ????
                        //画像をアップロードする
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
