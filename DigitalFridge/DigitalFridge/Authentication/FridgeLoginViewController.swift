//
//  FridgeLoginViewController.swift
//  DigitalFridge
//
//  Created by Debbie Pao on 11/29/17.
//  Copyright © 2017 Debbie Pao. All rights reserved.
//

import UIKit
import FirebaseAuth

class FridgeLoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextInput: UITextField!

    @IBOutlet weak var passwordTextInput: UITextField!
    
    var userEmail = ""
    var userPassword = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.emailTextInput.delegate = self
        self.passwordTextInput.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Checks if user is already signed in and skips login
        if FIRAuth.auth()?.currentUser != nil {
            self.performSegue(withIdentifier: "fromLogintoHome", sender: self)
        }
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        guard let emailText = emailTextInput.text else { return }
        guard let passwordText = passwordTextInput.text else { return }

        if emailText == "" || passwordText == "" {
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields
            let alertController = UIAlertController(title: "Login Error", message: "Please enter an email and password.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            FIRAuth.auth()?.signIn(withEmail: emailText, password: passwordText) { (user, error) in
                if error == nil {
                    self.performSegue(withIdentifier: "fromLogintoHome", sender: self)
                } else {
                    let alertController = UIAlertController(title: "Log In Error", message:
                        error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
   
    }
    
    
    @IBAction func signUpPressed(_ sender: UIButton) {
    self.performSegue(withIdentifier: "LogInToSignUp", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.emailTextInput {
            if textField.text != nil {
                self.userEmail = textField.text!
            }
        } else {
            if textField.text != nil {
                self.userPassword = textField.text!
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}
