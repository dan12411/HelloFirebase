//
//  ViewController.swift
//  HelloFirebase
//
//  Created by 洪德晟 on 2016/10/17.
//  Copyright © 2016年 洪德晟. All rights reserved.
//

import UIKit

// 匯入函式庫！！！！ //
import Firebase
import FBSDKLoginKit
import FirebaseAuth
import FBSDKShareKit

class ViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 定位到Root
        let  rootRef = FIRDatabase.database().reference()
//        // 把原本資料取代成"123"
//        rootRef.setValue("123")
//
//        // 建立新資料
//        let userTom = ["name" : "Tom", "age" : 15] as [String : Any]
//        let userMary = ["name" : "Mary", "age" : 13] as [String : Any]
//        
//        // 建立節點，把資料放進去
//        let userRef = rootRef.child("users")
//        // 建立AutoId給子節點
//        let userTomRef = userRef.childByAutoId()
//        userTomRef.setValue(userTom)
//        let userMaryRef = userRef.childByAutoId()
//        userMaryRef.setValue(userMary)
        
        // 定位到 users
        let usersRef = rootRef.child("users")
        
        // 用 oberve 檢視 users 節點底下新增的節點
        usersRef.observe(.childAdded, with: {
            snapshot in
            print("snapsot: \(snapshot)")
        })
        
        // 找 age 為 15 的資料(每筆資料都會查過一次)
        usersRef.queryOrdered(byChild: "age").queryEqual(toValue: 15).observe(.childAdded, with: {
            snapshot in
            print("snapsot: \(snapshot)")
        })
        
        
        // 上傳圖片到Firebase
//        let imagesRef = FIRDatabase.database().reference().child("images")
        let image = UIImage(named: "MyCat")
        let imageData = UIImageJPEGRepresentation(image!, 1.0)
//        let imageString = imageData?.base64EncodedString()
//        
//        let imageRef = imagesRef.child("MyCat")
//        imageRef.setValue(imageString)
        
        // 用Storage上傳圖片
        // Get a reference to the storage service, using the default Firebase App
        let storage = FIRStorage.storage()
        
        // Create a storage reference from our storage service
        let storageRef = storage.reference(forURL: "gs://hellofirebase-25df3.appspot.com")
        
        // Create a reference to"images/space.jpg"
        let spaceRef = storageRef.child("images/gakki.jpg")
        
        let uploadTask = spaceRef.put(imageData!, metadata: nil) { metadata, error in
            if (error != nil) {
                // Uh-oh, an error occurred!
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
                let downloadURL = metadata!.downloadURL
            }
        }
        
        uploadTask.resume()
        

        
        // 製作Facebook Login Button
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.center = self.view.center
        self.view.addSubview(loginButton)
        FBSDKProfile.enableUpdates(onAccessTokenChange: true)
        
        // 檢查是否有FB帳號
        if (FBSDKAccessToken.current() != nil) {
            print("FB Logined!!!!!!!!!")
            print("FB Token: \(FBSDKAccessToken.current().tokenString)")
        }
        print("~~~~~~~~~~~~~~~~~~~~~")
    }
    
    // 將使用者登入資料傳到Firebase
    @IBAction func loginFirebase(_ sender: AnyObject) {
        if FBSDKAccessToken.current() != nil {
            let fbToken = FBSDKAccessToken.current().tokenString
            let fireCredential = FIRFacebookAuthProvider.credential(withAccessToken: fbToken!)
            FIRAuth.auth()?.signIn(with: fireCredential, completion: {
                (user, error) in
                print("error: \(error?.localizedDescription)")
                print("Uid: \(user?.uid)")
                print("Name: \(user?.displayName)")
                
                self.firebaseUser = user
            })
        } else {
            //
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 按下按鈕後，下載&顯示圖片
    @IBAction func loadImage(_ sender: AnyObject) {
        let imageRef = FIRDatabase.database().reference().child("images/MyCat")
        imageRef.observe(.value, with: {
            snapshot in
            let imageString = snapshot.value as! String
            let imageData = Data(base64Encoded: imageString)
            let image = UIImage(data: imageData!)
            self.image.image = image
        })
    }
    
    // FB 分享網址
    @IBAction func shareContent(_ sender: AnyObject) {
        let content = FBSDKShareLinkContent()
        content.contentURL = URL(string:"https://www.google.com.tw")
        FBSDKShareDialog.show(from: self, with: content, delegate: nil)
    }
    
    // 顯示使用者大頭貼
    @IBAction func myProfile(_sender: AnyObject) {
        
        // 方法一 : 利用 API
        let url = FBSDKProfile.current().imageURL(for: .square, size: CGSize(width: 200, height: 200))
        let request = NSURLRequest(url: url!)
        let photoQueue = OperationQueue()
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: photoQueue, completionHandler: {
            (response, data, error) in
            if data != nil {
                let imagePhoto = UIImage(data: data!)
                self.image.image = imagePhoto
            }
        })
    
        // 方法二 : 利用 FBSDKProfilePictureView
        if let profile = FBSDKProfile.current() {
            if profile != nil {
                let imageView = FBSDKProfilePictureView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
                self.view.addSubview(imageView)
                imageView.profileID = profile.userID
            }
            print("nilnlinilnilnilinilnnll")
        }
        print("nilnlinilnilnilinilnnll~~~")
    }
    
    // 將 user 加入 database
    var firebaseUser: FIRUser?
    @IBAction func createUser(_ sender: AnyObject) {
        let rootRef = FIRDatabase.database().reference()
        let userRef = rootRef.child("users")
        
        let userSmart = ["name": "Smart", "age": 15] as [String: Any]
        
        if let user = firebaseUser {
            let smartRef = userRef.child(user.uid)
            smartRef.setValue(userSmart)
        }
        
    }
}

