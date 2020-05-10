//
//  ViewController.swift
//  Arjun_Dureja_iOS_Developer_PreprChallenge
//
//  Created by Arjun Dureja on 2020-05-08.
//  Copyright © 2020 Arjun Dureja. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var usernameField: AuthTextField!
    @IBOutlet weak var passwordField: AuthTextField!
    @IBOutlet weak var signInBtn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        usernameField.text = ""
        passwordField.text = ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        view.endEditing(true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .systemRed
        
        logo.image = UIImage(named: "logo")
        backgroundImage.backgroundColor = UIColor.white
        
        usernameField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        usernameField.addTarget(self, action: #selector(nextTapped), for: .editingDidEndOnExit)
        passwordField.addTarget(self, action: #selector(returnTapped), for: .editingDidEndOnExit)
        
        setupSignInBtn()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func nextTapped() {
        passwordField.becomeFirstResponder()
    }
    
    @objc func returnTapped() {
        view.endEditing(true)
    }
    
    func setupSignInBtn() {
        signInBtn.backgroundColor = UIColor(red: 128/255, green: 196/255, blue: 101/255, alpha: 1)
        signInBtn.layer.cornerRadius = 20
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        guard let username = usernameField.text else { return }
        guard let password = passwordField.text else { return }
        if username == "arjun" && password == "test" {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "labs") as? LabsViewController else { return }
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}

