//
//  PostData..swift
//  Instagram
//
//  Created by 竹内秀樹 on 2017/11/25.
//  Copyright © 2017年 hideki.takeuchi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class PostData: NSObject{
    var id: String?
    var image: UIImage?
    var imageString: String?
    var name: String?
    var caption: String?
    var date: NSDate?
    var likes: [String] = []
    var isLiked: Bool = false
    //課題対応
    //入力者コメント
    var comment: String?

    
    
    
    init(snapshot: DataSnapshot, myId: String){
        self.id = snapshot.key
        
        let valueDictionary = snapshot.value as! [String: AnyObject]
        
        imageString = valueDictionary["image"] as? String
        image = UIImage(data: NSData(base64Encoded: imageString!, options: .ignoreUnknownCharacters)! as Data)
        
        self.name = valueDictionary["name"] as? String
        
        self.caption = valueDictionary["caption"] as? String
        
        let time = valueDictionary["time"] as? String
        
        self.date = NSDate(timeIntervalSinceReferenceDate: TimeInterval(time!)!)
        
        if let likes = valueDictionary["likes"] as? [String]{
            self.likes = likes
        }
        
        for LikedID in self.likes{
            if LikedID == myId{
                self.isLiked = true
                break
            }
        }
        
       // let comment =
        
        
    }
    
}
