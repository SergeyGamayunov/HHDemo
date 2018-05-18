//
//  HHTextFieldView.swift
//  HeadsAndHandsDemo
//
//  Created by Сергей Гамаюнов on 17/05/2018.
//  Copyright © 2018 Сергей Гамаюнов. All rights reserved.
//

import UIKit

protocol HHTextFieldViewDelegate: class {
    func textFieldView(_ textFieldView: HHTextFieldView, isValid: Bool)
}

class HHTextFieldView: UIView {
    @IBOutlet var view: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var forgetPassButton: UIButton!
    
    weak var delegate: HHTextFieldViewDelegate?
    
    enum Mode { case login, password }

    var mode = Mode.login {
        didSet {
            changeModeTo(mode)
        }
    }
    
    // MARK: - Inits and view customization
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepareView()
    }
    
    func prepareView() {
        view = loadViewFromXib()
        view.frame = bounds
        self.addSubview(view)
        
        textField.delegate = self
    }
    
    func loadViewFromXib() -> UIView {
        let nibName = "HHTextFieldView"
        return Bundle.main.loadNibNamed(nibName, owner: self, options: [:])?[0] as! UIView
    }
    
    func changeModeTo(_ mode: Mode) {
        switch mode {
        case .password:
            titleLabel.text = "Пароль"
            forgetPassButton.isHidden = false
            textField.isSecureTextEntry = true
        case .login:
            titleLabel.text = "Логин"
            forgetPassButton.isHidden = true
            textField.isSecureTextEntry = false
        }
    }
}

extension HHTextFieldView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let isValid: Bool
        switch self.mode {
        case .login:
            isValid = HHFunction.isValidEmail(text)
        case .password:
            isValid = HHFunction.isValidPassword(text)
        }
        
        delegate?.textFieldView(self, isValid: isValid)
        
        return true
    }
}
