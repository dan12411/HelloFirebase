//
//  ViewController.swift
//  HelloFirebase
//
//  Created by 洪德晟 on 2016/10/17.
//  Copyright © 2016年 洪德晟. All rights reserved.
//

import UIKit

import Firebase

class ViewController: UIViewController {

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
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

