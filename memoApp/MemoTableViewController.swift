//
//  MemoTableViewController.swift
//  memoApp
//
//  Created by 篠原立樹 on 2018/10/31.
//  Copyright © 2018 Ostrich. All rights reserved.
//

import UIKit

class MemoTableViewController: UITableViewController {
    
    //UserDefaultsのインスタンスを取得
    let userDefaults = UserDefaults.standard
    
    //メモの内容を配列に
    var memos = [String]()
    
    //segueを巻き戻した時に実行
    @IBAction func unwindToMemoList(sender: UIStoryboardSegue) {
        //遷移元の画面を取得したいのでMemoViewControllerで型キャスト。memoにMemoViewControllerのmemoを代入
        guard let sourceVC = sender.source as? MemoViewController, let memo = sourceVC.memo else {
            //うまく行かなければ抜ける
            return
        }
        
        //cellが選択されているか(編集の時は直前でcellを選択するから)
        if let selectedIndexPath = self.tableView.indexPathForSelectedRow{
            //値を編集する
            self.memos[selectedIndexPath.row] = memo
        } else {
            //配列memoにmemoを追加
            self.memos.append(memo)
            
        }
        
        //userDefaultsに値を書き込む
        self.userDefaults.set(self.memos, forKey: "memos")
        
        //tableViewを再読み込み
        self.tableView.reloadData()
    }
    
    //移動許可
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    //編集許可
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //セル移動時の配列データ処理
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let targetTitle = memos[sourceIndexPath.row]
        if let index  = memos.index(of: targetTitle) {
            memos.remove(at: index)
            memos.insert(targetTitle, at: destinationIndexPath.row)
        }
        //userDefaultsに値を書き込む
        self.userDefaults.set(self.memos, forKey: "memos")
    }
    
        //削除アイコン表示分のスペースをインデントさせない
        override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
            return false
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //addButtonを有効にする
        self.addButton.isEnabled = true
        
        //navigation barの色を変更
        self.navigationController?.navigationBar.barTintColor = UIColor(red:127/255, green:191/255, blue:255/255, alpha:1)
        
        //navigation barのテキストについての設定
        self.navigationController?.navigationBar.titleTextAttributes = [
            // 文字の色
            .foregroundColor: UIColor.white
        ]
        
        //データがuserDefaultsに保存されていたら
        if self.userDefaults.object(forKey: "memos") != nil{
            //self.memoにself.userDefaultsから文字列の配列を引っ張ってくる
            self.memos = self.userDefaults.stringArray(forKey: "memos")!
        }

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        //セクションの個数を返す
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        //配列の個数を返す
        return self.memos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoTableViewCell", for: indexPath)

         //cellのテキストラベルに配列の値を代入
        cell.textLabel?.text = self.memos[indexPath.row]

        return cell
    }

    // スワイプして行を削除する
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //スワイプされた行の値を配列から削除する
            self.memos.remove(at: indexPath.row)
            //userDefaultsに値を書き込む
            self.userDefaults.set(self.memos, forKey: "memos")
            //スワイプされた行をtableViewから削除
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    //segueで遷移する前に呼び出される
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        //identifierがセットされているかチェック
        guard let identifier = segue.identifier else{
            return
        }
        //identifierがeditMemoかチェック
        if identifier == "editMemo" {
            //遷移先のViewControllerを取得
            let memoVC = segue.destination as! MemoViewController
            //遷移先のVCのmemoプロパティに選択されているmemoを入れる
            memoVC.memo = self.memos[(self.tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
    @IBOutlet weak var editButtonTitle: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    //editボタンが押されたら実行
    @IBAction func editButton(_ sender: Any) {
        //editモードの時なら
        if tableView.isEditing {
            //編集を不可能に
            tableView.isEditing = false
            //editButtonTitleの文字を変更
            editButtonTitle.title = "Edit"
            //addButtonを有効にする
            self.addButton.isEnabled = true
        } else {
            //編集を可能に
            tableView.isEditing = true
            //editButtonTitleの文字を変更
            editButtonTitle.title = "End"
            //addButtonを有効にする
            self.addButton.isEnabled = false
        }

    }
    
    //スワイプ削除を不可能にする
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        //editモードの時なら
        if tableView.isEditing {
            //削除を可能に
            return .delete
        }
        //削除を不可能に
        return .none
    }

    
    
}
