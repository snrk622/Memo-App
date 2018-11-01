//
//  MemoTableViewController.swift
//  memoApp
//
//  Created by 篠原立樹 on 2018/10/31.
//  Copyright © 2018 Ostrich. All rights reserved.
//

import UIKit

class MemoTableViewController: UITableViewController {
    
    //UserDefaultsのうインスタンスを取得
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        } else {
            //初期値を設定
            self.memos = ["memo1", "memo2", "memo3"]
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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

        //セクションにヘッダーをつける
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "section-\(section)"
//    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
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
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
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
    

}
