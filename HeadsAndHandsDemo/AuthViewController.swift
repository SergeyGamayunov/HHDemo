
import UIKit
import Alamofire

class AuthViewController: UIViewController {
    @IBOutlet weak var songTitleTextField: UITextField!
    @IBOutlet weak var loginTextFieldView: HHTextFieldView!
    @IBOutlet weak var passwordTextFieldView: HHTextFieldView!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var centerConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    
    var isLoginValid = false
    var isPassValid = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: .UIKeyboardWillHide, object: nil)
        
        hideKeyboard()
    }

    func setupView() {
        loginTextFieldView.mode = .login
        passwordTextFieldView.mode = .password
        
        for view in [loginTextFieldView, passwordTextFieldView] {
            view?.delegate = self
        }
        
        disableButton()
    }
    
    func enableButton() {
        enterButton.backgroundColor = HHColor.brand
        enterButton.isEnabled = true
    }
    
    func disableButton() {
        enterButton.backgroundColor = .lightGray
        enterButton.isEnabled = false
    }
    
    //MARK :- Keyboard stuff
    @objc func keyboardDidShow(_ notification: Notification) {
        adjustInsetForKeyboard(show: true, notification: notification)
        
    }
    
    @objc func keyboardDidHide(_ notification: Notification) {
        adjustInsetForKeyboard(show: false, notification: notification)
    }
    
    var differenceKB: CGFloat = 0
    func adjustInsetForKeyboard(show: Bool, notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let value = userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue
        else { return }
        
        let keyboardFrame = value.cgRectValue
        let distanceToBottom = UIScreen.main.bounds.height - containerView.frame.origin.y - containerView.bounds.height
        
        if distanceToBottom > keyboardFrame.height { return }
        
        if show {
            differenceKB = keyboardFrame.height - distanceToBottom
        }
        
        centerConstraint.constant -= differenceKB * (show ? 1 : -1)
        UIView.animate(withDuration: 0.1) {
            self.view.layoutSubviews()
        }
        
        if !show { differenceKB = 0 }
    }
    
    func showAlertWith(_ some: Any) {
        guard
            let json = some as? JSON,
            let results = json["results"] as? [JSON],
            let firstResult = results.first
        else {
            showAlertWith("Ошибка парсинга")
            return
        }
        
        if let trackName = firstResult["trackName"] as? String {
            showAlertWith(trackName)
        } else {
            showAlertWith("Ничего не найдено.")
        }
        
    }
    
    func showAlertWith(_ string: String) {
        let alert = UIAlertController(title: "Результат", message: string, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    

    @IBAction func enter(_ sender: Any) {
        let term = songTitleTextField.text ?? ""
        let url = HHEndpoint.search(term).url
        let params = HHEndpoint.search(term).parameters
        
        Alamofire.request(url, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case .success(let json):
                self.showAlertWith(json)
            case .failure(let error):
                self.showAlertWith(error.localizedDescription)
            }
        }
    }
}

extension AuthViewController: HHTextFieldViewDelegate {
    func textFieldView(_ textFieldView: HHTextFieldView, isValid: Bool) {
        switch textFieldView.mode {
        case .login:
            isLoginValid = isValid
        case .password:
            isPassValid = isValid
        }
        
        isLoginValid && isPassValid ? enableButton() : disableButton()
    }
}

