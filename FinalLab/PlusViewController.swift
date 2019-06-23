//
//  PlusViewController.swift
//  FinalLab
//
//  Created by SWUCOMPUTER on 22/06/2019.
//  Copyright © 2019 SWUCOMPUTER. All rights reserved.
//

import UIKit

class PlusViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func upLoad(_ sender: UIButton) {
        if sender.isTouchInside{
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
}
