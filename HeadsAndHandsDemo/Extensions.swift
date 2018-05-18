//
//  Extensions.swift
//  HeadsAndHandsDemo
//
//  Created by Сергей Гамаюнов on 17/05/2018.
//  Copyright © 2018 Сергей Гамаюнов. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
