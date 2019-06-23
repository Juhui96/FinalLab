//
//  PostViewController.swift
//  FinalLab
//
//  Created by SWUCOMPUTER on 22/06/2019.
//  Copyright © 2019 SWUCOMPUTER. All rights reserved.
//

import UIKit
import CoreData

class PostViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {


    
    @IBOutlet var postTableView: UITableView!
    var selectedData: FavoriteData?
    
    var comment:String = ""
    
    var fetchedArray: [FavoriteData] = Array() // 서버에서 가져온 데이터의 묶음

    
    override func viewDidLoad() {
        super.viewDidLoad()

        postTableView.delegate = self
        postTableView.dataSource = self
        
        self.postTableView.rowHeight = 500; // 테이블 셀의 높이를 설정
    }
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        fetchedArray = [] // 배열을 초기화하고 서버에서 자료를 다시 가져옴
        self.downloadDataFromServer()
    }
    
    // 서버에 저장된 데이터를 가져오는 코드
    func downloadDataFromServer() -> Void {
        let urlString: String = "http://condi.swu.ac.kr/student/M09/favoriteTable.php"
        guard let requestURL = URL(string: urlString) else { return }
        let request = URLRequest(url: requestURL)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (responseData, response, responseError) in guard responseError == nil else { print("Error: calling POST"); return; }
            guard let receivedData = responseData else {
                print("Error: not receiving Data"); return; }
            let response = response as! HTTPURLResponse
            if !(200...299 ~= response.statusCode) { print("HTTP response Error!"); return }
            do {
                if let jsonData = try JSONSerialization.jsonObject (with: receivedData,
                                                                    options:.allowFragments) as? [[String: Any]] {
                    for i in 0...jsonData.count-1 {
                        let newData: FavoriteData = FavoriteData()
                        var jsonElement = jsonData[i]
                        newData.favoriteno = jsonElement["favoriteno"] as! String
                        newData.userid = jsonElement["id"] as! String
                        newData.descript = jsonElement["description"] as! String
                        newData.imageName = jsonElement["imageName"] as! String
                        newData.date = jsonElement["date"] as! String
                        self.fetchedArray.append(newData)
                    }
                    DispatchQueue.main.async { self.postTableView.reloadData() } }
            } catch { print("Error: Catch") } }
        task.resume()
        
        //서버에서 댓글 가져와서 fetchedArray에 append
        let urlString2: String = "http://condi.swu.ac.kr/student/M09/commentTable.php"
        guard let requestURL2 = URL(string: urlString2) else { return }
        let request2 = URLRequest(url: requestURL2)
        let session2 = URLSession.shared
        let task2 = session2.dataTask(with: request2) { (responseData, response, responseError) in guard responseError == nil else { print("Error: calling POST"); return; }
            guard let receivedData2 = responseData else {
                print("Error: not receiving Data"); return; }
            let response2 = response as! HTTPURLResponse
            if !(200...299 ~= response2.statusCode) { print("HTTP response Error!"); return }
            do {
                if let jsonData2 = try JSONSerialization.jsonObject (with: receivedData2,
                                                                    options:.allowFragments) as? [[String: Any]] {
                    for i in 0...jsonData2.count-1 {
                        let newData2: FavoriteData = FavoriteData()
                        var jsonElement2 = jsonData2[i]
                        newData2.comment = jsonElement2["comment"] as! String
                      
                        self.fetchedArray.append(newData2)
                    }
                    DispatchQueue.main.async { self.postTableView.reloadData() } }
            } catch { print("Error: Catch") } }
        task2.resume()
    }
    //
    
    //테이블 구성 코드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Post Cell", for: indexPath) as! PostTableViewCell
        
        //let row:Int = indexPath.row
        
        let item = fetchedArray[indexPath.row]
        self.selectedData = item
        cell.idButton.setTitle(item.userid, for: .normal)
        cell.imageNameLabel.text = item.descript
        
        comment = cell.commentTF.text!
        
        
        cell.commentLabel.text = item.comment
        cell.dateLabel.text = item.date
        var imageName = item.imageName
        if (imageName != "") {
            let urlString = "http://condi.swu.ac.kr/student/favorite/"
            imageName = urlString + imageName
            let url = URL(string: imageName)!
            if let imageData = try? Data(contentsOf: url) {
                cell.postImage.image = UIImage(data: imageData)
            }
        }
        return cell
    }
    //
    
    //댓글 관련 코드 - 서버 사용 (Comment테이블, id, comment )
    @IBAction func upLoadComment() {
        
        var name2: String = ""
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        /* let urlString: String = http://localhost:8888/login/insertUser.php */
        let urlString: String = "http://condi.swu.ac.kr/student/M09/insertComment.php"
        guard let requestURL = URL(string: urlString) else {
            return
        }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        if let name = appDelegate.userName{
            name2 = name
        }
        let restString: String = "id=" +  name2 + "&comment=" + comment
        request.httpBody = restString.data(using: .utf8)
        self.executeRequest(request: request)
        
//        if let name = appDelegate.userName {
//            let restString: String = "id=" + name + "&comment=" + comment
//            request.httpBody = restString.data(using: .utf8)
//            self.executeRequest(request: request)
//        }
        self.downloadDataFromServer()
    }
    func executeRequest (request: URLRequest) -> Void {
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else {
                print("Error: calling POST")
                return
            }
            
            guard let receivedData = responseData else {
                print("Error: not receiving Data")
                return
            }
            
            if let utf8Data = String(data: receivedData, encoding: .utf8) {
                DispatchQueue.main.async {
                    //self.labelStatus.text = utf8Data
                    let alert = UIAlertController(title: "Insert Done",
                                                  message: "저장완료", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in alert.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true)
                    
                    print(utf8Data)  // php에서 출력한 echo data가 debug 창에 표시됨
                }
            }
        }
        task.resume()
    }
    //
    
    //좋아요 수 관련 코드 - 서버 사용 (Hart, id - varchar(10), like - int(11, null))
    // executeRequest 추가 안함
    // insertHart.php 안함
    // 정리후에 다시 할 것
    @IBAction func hartPressed(_ sender: UIButton) {
        /*
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var likes:Int = 0
        if sender.isTouchInside{
            likes += 1;
            let urlString: String = "http://condi.swu.ac.kr/student/login/insertHart.php"
            guard let requestURL = URL(string: urlString) else {
                return
            }
            var request = URLRequest(url: requestURL)
            request.httpMethod = "POST"
            if let name = appDelegate.userName {
                let restString: String = "id=" + name + "&like=" + String(likes)
                request.httpBody = restString.data(using: .utf8)
                self.executeRequest(request: request)
            }
        }
         */
    }
   
    //
     /* 댓글보기 할때 사용하기
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // Get the new view controller using segue.destinationViewController. // Pass the selected object to the new view controller.
     if segue.identifier == "toDetailView" {
     if let destination = segue.destination as? DetailViewController {
     if let selectedIndex = self.tableView.indexPathsForSelectedRows?.first?.row {
     let data = fetchedArray[selectedIndex]
     destination.selectedData = data
     destination.title = data.name
     }
     }
     }
     }
     */
    
    @IBAction func deletePost() {
        let alert=UIAlertController(title:"정말 삭제 하시겠습니까?", message: "",preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .cancel, handler: { action in
            let urlString: String = "http://condi.swu.ac.kr/student/M09/deleteFavorite.php"
            guard let requestURL = URL(string: urlString) else { return }
            var request = URLRequest(url: requestURL)
            request.httpMethod = "POST"
            guard let favoriteNO = self.selectedData?.favoriteno else { return }
            let restString: String = "favoriteno=" + favoriteNO
            request.httpBody = restString.data(using: .utf8)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { (responseData, response, responseError) in guard responseError == nil else { return }
                guard let receivedData = responseData else { return }
                if let utf8Data = String(data: receivedData, encoding: .utf8) { print(utf8Data) }
            }
            task.resume()
            self.fetchedArray = [] // 배열을 초기화하고 서버에서 자료를 다시 가져옴
            self.downloadDataFromServer()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true)
        
    }
}
