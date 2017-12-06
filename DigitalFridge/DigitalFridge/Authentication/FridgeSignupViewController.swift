//
//  FridgeSignupViewController.swift
//  DigitalFridge
//
//  Created by Debbie Pao on 11/29/17.
//  Copyright © 2017 Debbie Pao. All rights reserved.
//

import UIKit
import FirebaseAuth

class FridgeSignupViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var passwordVerificationTextField: UITextField!
    
    var userEmail = ""
    var userPassword = ""
    var userVerifiedPassWord = ""
    
    @IBAction func signUpButtonIsPressed(_ sender: UIButton) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let verifiedPassword = passwordVerificationTextField.text else { return }
        if email == "" || password == "" || verifiedPassword == "" {
            let alertController = UIAlertController(title: "Form Error.", message: "Please fill in form completely.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        } else {
            FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
                if error == nil {
                    // TO DO:
                    // The user account has been successfully created. Now, update the user's name in
                    // firebase and then perform a segue to the main page. Note, again, that this segue
                    // already exists somewhere, just do some simple debugging to find the identifier.
                    // Also, notify the user that the account has been successfully created before
                    // performing the segue.
                    let alertController = UIAlertController(title: "Success!", message: "You're account has successfully been created!", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.performSegue(withIdentifier: "fromSignuptoHome", sender: self)
                    self.present(alertController, animated: true, completion: nil)
                } else if password != verifiedPassword {
                    let alertController = UIAlertController(title: "Verification Error.", message: "The two passwords do not match.", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.passwordVerificationTextField.textColor = UIColor.red
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Sign Up Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    @IBAction func goToLoginPage(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToLogin", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.passwordVerificationTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.emailTextField {
            if textField.text != nil {
                self.userEmail = textField.text!
            }
        } else if textField == self.passwordTextField {
            if textField.text != nil {
                self.userPassword = textField.text!
            }
        } else if textField == self.passwordVerificationTextField {
            if textField.text != nil {
                self.userVerifiedPassWord = textField.text!
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
