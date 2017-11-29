//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by 竹内秀樹 on 2017/11/26.
//  Copyright © 2017年 hideki.takeuchi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SVProgressHUD

class PostTableViewCell: UITableViewCell,UITextFieldDelegate {
    
    var postArray: [PostData] = []
    
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var myTextField: UITextField!
    
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBAction func commentButton(_ sender: Any) {
        
        
        // ImageViewから画像を取得する
        let imageData = UIImageJPEGRepresentation(postImageView.image!, 0.5)
        let imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
        
        // postDataに必要な情報を取得しておく
        let time = NSDate.timeIntervalSinceReferenceDate
        let name = Auth.auth().currentUser?.displayName
        
        // 保持している配列からidが同じものを探す
        
        var index: Int = 0
        for post in self.postArray {
            if post.id == ().id {
                index = self.postArray.index(of: post)!
                break
            }
        }
        
        // 増えたcommentをFirebaseに保存する
        
        let postRef = Database.database().reference().child(Const.PostPath).child(index)
        let postData = ["caption": captionLabel.text!,"comment": myTextField.text!, "image": imageString, "time": String(time), "name": name!]
        let comment = ["comment": postData.comment]
        postRef.updateChildValues(comment)
        
        
        // 辞書を作成してFirebaseに保存する
      //  let postRef = Database.database().reference().child(Const.PostPath)
      //  let postData = ["caption": captionLabel.text!,"comment": myTextField.text!, "image": imageString, "time": String(time), "name": name!]
        
      //  postRef.childByAutoId().setValue(postData)
        
       // postRef.updateChildValues(postData)
        
        
        // HUDで投稿完了を表示する
        SVProgressHUD.showSuccess(withStatus: "コメント投稿しました")
        
        
    }
    @IBOutlet weak var commentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        myTextField.delegate = self
        
        //過去のコメントなどを表示
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    // 課題対応
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        print("textFieldShouldReturn \(myTextField.text!)")
        
        textField.resignFirstResponder()
        
        print("textFieldShouldReturn \(myTextField.text!)")
        
        return true
    }
    // 課題対応
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        print("textFieldDidEndEditing \(myTextField.text!)")
        

    }
    
    func setPostData(postData: PostData){
        self.postImageView.image = postData.image
        self.captionLabel.text = "\(postData.name!): \(postData.caption!)"
        
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"
        
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale!
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString:String = formatter.string(from: postData.date! as Date)
        self.dateLabel.text = dateString
        
        if postData.isLiked{
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: UIControlState.normal)
        }else{
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: UIControlState.normal)
        }
        //課題対応
        self.myTextField.text = postData.comment
        
    }
    
}
