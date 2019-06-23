//
//  MyViewController.swift
//  FinalLab
//
//  Created by SWUCOMPUTER on 06/06/2019.
//  Copyright © 2019 SWUCOMPUTER. All rights reserved.
//

import UIKit

class MyViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    
    
    
    @IBOutlet var myTableView: UITableView!
    
    @IBOutlet var uploadButton: UIButton!
    
    var myFetchedArray: [FavoriteData] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myTableView.delegate = self
        myTableView.dataSource = self
        
        self.myTableView.rowHeight = 450;
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let name = appDelegate.userName {
            self.title = name
        }
    }
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        myFetchedArray = [] // 배열을 초기화하고 서버에서 자료를 다시 가져옴
        self.downloadDataFromServer()
    }
    func downloadDataFromServer() -> Void {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
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
                        if let name = appDelegate.userName {
                            if newData.userid == name{
                                 self.myFetchedArray.append(newData)
                            }
                        }
                    }
                    DispatchQueue.main.async { self.myTableView.reloadData() } }
            } catch { print("Error: Catch") } }
        task.resume()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myFetchedArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPost Cell", for: indexPath) as! PostTableViewCell
        
        //let row:Int = indexPath.row
        
        let item = myFetchedArray[indexPath.row]
        cell.myIdButton.setTitle(item.userid, for: .normal)
        cell.myDateLabel.text = item.date
        cell.myImageNameLabel.text = item.descript
        cell.myCommentLabel.text = item.comment
        var imageName = item.imageName
        if (imageName != "") {
            let urlString = "http://condi.swu.ac.kr/student/favorite/"
            imageName = urlString + imageName
            let url = URL(string: imageName)!
            if let imageData = try? Data(contentsOf: url) {
                cell.myPostImage.image = UIImage(data: imageData)
                //cell.imageNameLabel.text = imageName
            }
        }
        return cell
    }
    
    
}
