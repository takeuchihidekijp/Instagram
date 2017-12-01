//
//  HomeViewController.swift
//  Instagram
//
//  Created by 竹内秀樹 on 2017/11/10.
//  Copyright © 2017年 hideki.takeuchi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var postArray: [PostData] = []
    
    // DatabaseのobserveEventの登録状態を表す
    var observing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // テーブルセルのタップを無効にする
        tableView.allowsSelection = false
        
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("DEBUG_PRINT: viewWillAppear")
        
        if Auth.auth().currentUser != nil{
            if self.observing == false {
                // 要素が追加されたらpostArrayに追加してTableViewを再表示する
                let postsRef = Database.database().reference().child(Const.PostPath)
                postsRef.observe(.childAdded, with: { snapshot in
                    print("DEBUG_PRINT: .childAddedイベントが発生しました。")
                    
                    // PostDataクラスを生成して受け取ったデータを設定する
                    if let uid = Auth.auth().currentUser?.uid{
                        let postData = PostData(snapshot: snapshot, myId: uid)
                        self.postArray.insert(postData, at: 0)
                        
                        // TableViewを再表示する
                        self.tableView.reloadData()
                    }
                    
                })
                // 要素が変更されたら該当のデータをpostArrayから一度削除した後に新しいデータを追加してTableViewを再表示する
                postsRef.observe(.childChanged, with: { snapshot in
                    print("DEBUG_PRINT: .childChangedイベントが発生しました。")
                    
                    if let uid = Auth.auth().currentUser?.uid{
                        // PostDataクラスを生成して受け取ったデータを設定する
                        let postData = PostData(snapshot: snapshot, myId: uid)
                        
                        // 保持している配列からidが同じものを探す
                        var index: Int = 0
                        for post in self.postArray{
                            if post.id == postData.id{
                                index = self.postArray.index(of: post)!
                                break
                            }
                        }
                        // 差し替えるため一度削除する
                        self.postArray.remove(at: index)
                        
                        // 削除したところに更新済みのでデータを追加する
                        self.postArray.insert(postData, at: index)
                        
                        // TableViewの現在表示されているセルを更新する
                        self.tableView.reloadData()
                        
                    }
                    
                })
                // DatabaseのobserveEventが上記コードにより登録されたため
                // trueとする
                observing = true
                
            }
        }else{
            if observing == true{
                // ログアウトを検出したら、一旦テーブルをクリアしてオブザーバーを削除する。
                // テーブルをクリアする
                postArray = []
                tableView.reloadData()
                
                // オブザーバーを削除する
                Database.database().reference().removeAllObservers()
                
                // DatabaseのobserveEventが上記コードにより解除されたため
                // falseとする
                observing = false

            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得してデータを設定する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! PostTableViewCell
        cell.setPostData(postData: postArray[indexPath.row])
        
        // セル内のボタンのアクションをソースコードで設定する
        cell.likeButton.addTarget(self, action:#selector(handleButton(sender:event:)), for:  UIControlEvents.touchUpInside)
        
        //課題対応
        cell.comButton.addTarget(self, action: #selector(commonButton(sender:event:)), for: UIControlEvents.touchUpInside)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        // Auto Layoutを使ってセルの高さを動的に変更する
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルをタップされたら何もせずに選択状態を解除する
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    //課題対応
    func commonButton(sender: UIButton,event:UIEvent){
        print("DEBUG_PRINT: commentボタンがタップされました。")
        
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        let cell = tableView.cellForRow(at: indexPath!) as! PostTableViewCell
        
        // 配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]
        
        postData.comment.append("\(postData.name!) : \(cell.myTextField.text!)")
        

        
        let postRef = Database.database().reference().child(Const.PostPath).child(postData.id!)
        let comment = ["comment": postData.comment]
        postRef.updateChildValues(comment)
        
        // HUDで投稿完了を表示する
        SVProgressHUD.showSuccess(withStatus: "コメントを投稿しました")
        
    }
    
    // セル内のボタンがタップされた時に呼ばれるメソッド
    func handleButton(sender: UIButton, event:UIEvent){
        print("DEBUG_PRINT: likeボタンがタップされました。")
        
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        // 配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]
        
        // Firebaseに保存するデータの準備
        if let uid = Auth.auth().currentUser?.uid{
            if postData.isLiked{
                // すでにいいねをしていた場合はいいねを解除するためIDを取り除く
                var index = -1
                for likeId in postData.likes{
                    if likeId == uid{
                        // 削除するためにインデックスを保持しておく
                        index = postData.likes.index(of: likeId)!
                        break
                    }
                }
                postData.likes.remove(at: index)
            }else{
                postData.likes.append(uid)
            }
            
            // 増えたlikesをFirebaseに保存する
            let postRef = Database.database().reference().child(Const.PostPath).child(postData.id!)
            let likes = ["likes": postData.likes]
            postRef.updateChildValues(likes)
            
        }
        
        
    }
    
    
}
