//
//  FavoriteData.swift
//  FinalLab
//
//  Created by SWUCOMPUTER on 21/06/2019.
//  Copyright © 2019 SWUCOMPUTER. All rights reserved.
//

import UIKit

class FavoriteData: NSObject {

    // 모든 자료는 입력 전에 nil 인지 확인하게 됨
    // 모든 자료가 nil이 아니므로 Optional 타입이 아니며 // 이 경우, init() 함수를 정의하던지 초기값을 주어야 함
    var favoriteno: String = ""
    var userid: String = ""
    var descript: String = ""
    var imageName: String = ""
    var date: String = ""
    
    var comment:String = ""
}
