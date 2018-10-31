//
//  MemoViewController.swift
//  memoApp
//
//  Created by 篠原立樹 on 2018/10/31.
//  Copyright © 2018 Ostrich. All rights reserved.
//

import UIKit

class MemoViewController: UIViewController {
    
    var memo: String?

    @IBOutlet weak var memoTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //saveButtonを無効にしておく
        self.saveButton.isEnabled = false
        
        //memoがうまく渡せていたら
        if let memo = self.memo {
            //memoTextFieldにmemoを代入
            self.memoTextField.text = memo
            //titleを変える
            self.navigationItem.title = "Edit Memo"
        }
        self.updateSaveButtonState()

    }
    
    private func updateSaveButtonState() {
        //memoにmemoTextFieldの値を代入
        let memo = self.memoTextField.text ?? ""
        //saveButtonが有効になるのは、memoが空文字じゃないとき
        self.saveButton.isEnabled = !memo.isEmpty
    }
    
    @IBAction func memoTextFieldChanged(_ sender: Any) {//memoTextFieldのtextが変更された時に実行
        self.updateSaveButtonState()
        
    }
    
    @IBAction func cancel(_ sender: Any) {//cancelが押されたら実行
        
        //presentingViewControllerがUINavigationControllerだったら
        if self.presentingViewController is UINavigationController {
            //単にこのモーダルを消したいときはdismiss
            self.dismiss(animated: true, completion: nil)
        } else {
            //showしたsegueを逆に戻る
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {//saveButtonが押されたらsenderにsaveButtonが入る
        //buttonにdender(saveButton)を入れてUIBarButtonItemに型キャスト。そしてbuttonがsaveButtonか確認する。違うならreturnで抜ける
        guard let button = sender as? UIBarButtonItem, button === self.saveButton else{
            return
        }
        
        //memoに値を設定。nilなら空文字
        self.memo = self.memoTextField.text ?? ""
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
