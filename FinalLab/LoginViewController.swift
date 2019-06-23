//
//  LoginViewController.swift
//  FinalLab
//
//  Created by SWUCOMPUTER on 06/06/2019.
//  Copyright © 2019 SWUCOMPUTER. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController , UITextFieldDelegate    {

    @IBOutlet var loginID: UITextField!
    @IBOutlet var loginPassword: UITextField!
    @IBOutlet var labelStatus: UILabel!
    
    func textFieldShouldReturn (_ textField: UITextField) -> Bool {   //delegate method
        if textField == self.loginID {
            textField.resignFirstResponder()
            self.loginPassword.becomeFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    @IBAction func loginPressed() {
        if loginID.text == "" {
            labelStatus.text = "ID를 입력하세요"; return;
        }
        if loginPassword.text == "" {
            labelStatus.text = "비밀번호를 입력하세요"; return;
        }
        /* let urlString: String = http://localhost:8888/login/loginUser.php */
        let urlString: String = "http://condi.swu.ac.kr/student/M09/login/loginUser.php"
        guard let requestURL = URL(string: urlString) else {
            return
        }
        self.labelStatus.text = " "
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        let restString: String = "&id=" + loginID.text! + "&password=" + loginPassword.text!
        
        request.httpBody = restString.data(using: .utf8)
        
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
            
            do {
                let response = response as! HTTPURLResponse
                if !(200...299 ~= response.statusCode) {
                    print ("HTTP Error!")
                    return
                }
                guard let jsonData = try JSONSerialization.jsonObject(with: receivedData,
                                                                      options:.allowFragments) as? [String: Any]
                    else {
                        print("JSON Serialization Error!")
                        return
                }
                guard let success = jsonData["success"] as? String else {
                    print("Error: PHP failure(success)")
                    return
                }
                if success == "YES" {
                    if let name = jsonData["name"] as? String {
                        DispatchQueue.main.async {
                            self.labelStatus.text = name + "님 안녕하세요?"
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.ID = self.loginID.text
                            appDelegate.userName = name
                            self.performSegue(withIdentifier: "toLoginSuccess", sender: self)
                        }
                    }
                } else {
                    if let errMessage = jsonData["error"] as? String {
                        DispatchQueue.main.async {
                            self.labelStatus.text = errMessage  }
                    }
                }
            } catch {
                print("Error: \(error)")
            }
        }
        task.resume()
    }
}
