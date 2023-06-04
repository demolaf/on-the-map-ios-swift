//
//  ViewController.swift
//  On The Map
//
//  Created by Ademola Fadumo on 25/05/2023.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
        
        self.setupAppearance()
    }
    
    func setupAppearance() {
        let title = "Don't have an account? Sign Up"
        let range = title.range(of: "Sign Up")!
        let convertedRange = NSRange(range, in: title)
        let attributedString = NSMutableAttributedString(string: title)
        
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Colors.primary, range: convertedRange)
        
        self.signupButton.setAttributedTitle(attributedString, for: .normal)
    }
    
    @IBAction func loginTapped() {
        self.setLoggingIn(true)
        NetworkClient.login(username: emailTextField.text!, password: passwordTextField.text!, completion: self.handleLoginResponse(success:error:))
    }
    
    @IBAction func signupTapped() {
        DispatchQueue.main.async {
            UIApplication.shared.open(NetworkClient.Endpoints.signup.url, options: [:], completionHandler: nil)
        }
    }
    
    private func handleLoginResponse(success: Bool, error: Error?) {
        self.setLoggingIn(false)
        if success {
            NetworkClient.getUserPublicData { response, error in
                UserPublicData.userPublicData = response
            }
            
            let mainTabBarController = storyboard?.instantiateViewController(withIdentifier: "MainTabBarController")
            navigationController?.pushViewController(mainTabBarController!, animated: true)
        } else {
            self.setLoggingIn(false)
            self.showUIAlertView(title: "Login Failed", message: error?.localizedDescription ?? "")
        }
    }
    
    private func setLoggingIn(_ loggingIn: Bool) {
            if loggingIn {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
            
            self.emailTextField.isEnabled = !loggingIn
            self.passwordTextField.isEnabled = !loggingIn
            self.loginButton.isEnabled = !loggingIn
            self.signupButton.isEnabled = !loggingIn
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

