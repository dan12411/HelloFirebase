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
        
        // 用Storage上傳圖片(未完成)
        // Get a reference to the storage service, using the default Firebase App
        let storage = FIRStorage.storage()
        
        // Create a storage reference from our storage service
        let storageRef = storage.reference(forURL: "gs://hellofirebase-25df3.appspot.com")
        
        // Create a reference to"images/space.jpg"
        let spaceRef = storageRef.child("images/MyCat.jpg")
        
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
        
        // 檢查是否有FB帳號
        if (FBSDKAccessToken.current() != nil) {
            print("FB Logined!!!!!!!!!")
            print("FB Token: \(FBSDKAccessToken.current().tokenString)")
        }
        
        print("~~~~~~~~~~~~~~~~~~~~~")
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
}

