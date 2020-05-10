//
//  SignUpViewController.swift
//  Arjun_Dureja_iOS_Developer_PreprChallenge
//
//  Created by Arjun Dureja on 2020-05-10.
//  Copyright © 2020 Arjun Dureja. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    @IBOutlet weak var emailField: AuthTextField!
    @IBOutlet weak var passwordField: AuthTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Sign Up"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(submitTapped))
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor.customGreen
        navigationItem.leftBarButtonItem?.tintColor = UIColor.customGreen
        
        emailField.addTarget(self, action: #selector(nextTapped), for: .editingDidEndOnExit)
        passwordField.addTarget(self, action: #selector(returnTapped), for: .editingDidEndOnExit)
    }
    
    @objc func nextTapped() {
        passwordField.becomeFirstResponder()
    }
    
    @objc func returnTapped() {
        view.endEditing(true)
    }
    
    @objc func cancelTapped() {
        popViewController()
    }
    
    @objc func submitTapped() {
        let email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if email != "" && password != "" {
            if password!.count >= 6 {
                Auth.auth().createUser(withEmail: email!, password: password!) { (result, error) in
                    if error != nil {
                        self.showError(error!.localizedDescription)
                    } else {
                        let db = Firestore.firestore()
                        
                        db.collection("users").addDocument(data: ["uid": result!.user.uid], completion: { (error) in
                            
                            if error != nil {
                                self.showError(error!.localizedDescription)
                            }
                        })
                        self.successHandler()
                    }
                }
            } else {
                showError("Password must be greater than 6 characters")
            }
        } else {
            showError("Please fill all fields!")
        }
    }
    
    func showError(_ err: String) {
        let ac = UIAlertController(title: "Error", message: err, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        return
    }
    
    func successHandler() {
        let ac = UIAlertController(title: "Success", message: "Account successfully created, please login", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            [weak self] _ in
            self?.popViewController()
        }))
        present(ac, animated: true)
        return
    }

    func popViewController() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .push
        transition.subtype = .fromBottom
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.popViewController(animated: true)
    }

}
