//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by 竹内秀樹 on 2017/11/26.
//  Copyright © 2017年 hideki.takeuchi. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell,UITextFieldDelegate {
    
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var myTextField: UITextField!
    
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBAction func commentButton(_ sender: Any) {
        
        
    }
    @IBOutlet weak var commentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        myTextField.delegate = self
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
