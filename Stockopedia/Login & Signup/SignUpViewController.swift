//
//  SignUpViewController.swift
//  Stockopedia
//
//  Created by Nathan Turcich on 3/28/19.
//  Copyright © 2019 Joey Chung. All rights reserved.
//

import UIKit

var currentID:String = ""
var currentUsername:String = ""

class SignUpViewController: UIViewController {

    //MARK: - Variables
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    //MARK: - Views Appearing
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signUpButtonAction(_ sender: UIButton) {
        if(usernameTextField.text != "" && passwordTextField.text != "") {
            let key = Utils.randomString(length: 15)
            DownloadData.createUser(key: key, username: usernameTextField.text!, password: passwordTextField.text!)
            currentID = key
            currentUsername = usernameTextField.text!
            DownloadData.initilizeUsersRecomendations(key: currentID)
            UserDefaults.standard.set(currentID, forKey: "currentID")
            UserDefaults.standard.set(currentUsername, forKey: "currentUsername")
            self.dismiss(animated: true, completion: nil)
        }
        else { Utils.createAlertWith(message: "Fill in all fields.", viewController: self) }
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
