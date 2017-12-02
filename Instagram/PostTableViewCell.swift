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
    //課題対応
    var comment_work: String?
    var comment_data: String?
    
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var myTextField: UITextField!
    
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var comButton: UIButton!
    
    @IBOutlet weak var CommentLabel: UILabel!
    
    @IBAction func commentButton(_ sender: Any) {
        
        
        // ImageViewから画像を取得する
        let imageData = UIImageJPEGRepresentation(postImageView.image!, 0.5)
        let imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
        
        // postDataに必要な情報を取得しておく
        let time = NSDate.timeIntervalSinceReferenceDate
        let name = Auth.auth().currentUser?.displayName
        
        let postData = ["caption": captionLabel.text!,"comment": myTextField.text!, "image": imageString, "time": String(time), "name": name!]
        
        
        
    }

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

        
        textField.resignFirstResponder()

        
        return true
    }
    // 課題対応
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        

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
        let commentNumber = postData.comment.count
        
        print("commentNumber: \(commentNumber)")
      //  self.myTextField.text = postData.comment[1]
        //コメント表示を行単位で出力する
        for a in 0 ..< commentNumber{
            print("coment: \(postData.comment)")
            print("coment_a: \(postData.comment[a])")
            print("coment_work: \(comment_work!)")
            print("coment_work: \(comment_data!)")
            comment_work = "\(postData.comment[a]))"
            comment_data! = comment_data! + ("\n") + comment_work!
        }
      //  self.CommentLabel.text = "\(postData.comment)"
        print("coment_after: \(postData.comment)")
        
      //  self.CommentLabel.text = "\(postData.comment[a])"
        print("coment_after: \(postData.comment)")
        self.CommentLabel.text = "\(comment_data)"
    }
    
}
