//
//  HHFunction.swift
//  HeadsAndHandsDemo
//
//  Created by Сергей Гамаюнов on 18/05/2018.
//  Copyright © 2018 Сергей Гамаюнов. All rights reserved.
//

import UIKit

enum HHFunction {
    static func isValidEmail(_ email: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.count)) != nil
    }
    
    static func isValidPassword(_ password: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{6,}$")
        return regex.firstMatch(in: password, options: [], range: NSRange(location: 0, length: password.count)) != nil
    }
}

enum HHColor {
    static let brand = UIColor(red: 253/255, green: 137/255, blue: 9/255, alpha: 1.0)
}
