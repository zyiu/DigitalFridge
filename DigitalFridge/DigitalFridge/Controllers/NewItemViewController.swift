//
//  NewItemViewController.swift
//  DigitalFridge
//
//  Created by Debbie Pao on 11/29/17.
//  Copyright © 2017 Debbie Pao. All rights reserved.
//

import UIKit

class NewItemViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var expirationField: UITextField!
    
    @IBOutlet weak var dateField: UITextField!
    
    var chosenImage: UIImage?
    @IBOutlet weak var chosenImageView: UIImageView!
    
    
    var name = ""
    var expirationDate = ""
    var dateBought = ""
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        guard let userName = nameField.text else { return }
        guard let expirDate = expirationField.text else { return }
        guard let dateBuy = dateField.text else { return }
        
        if let imageToPost = chosenImage {
            addItem(itemName: userName, expirDate: expirDate, dateBought: dateBuy, postImage: imageToPost)
            performSegue(withIdentifier: "goToHomePage", sender: nil)
        } else {
            addItem(itemName: userName, expirDate: expirDate, dateBought: dateBuy)
            performSegue(withIdentifier: "goToHomePage", sender: nil)
        }
        
    }
    
    @IBAction func cameraPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToImagePicker", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.nameField {
            if textField.text != nil {
                self.name = textField.text!
            }
        } else if textField == self.expirationField {
            if textField.text != nil {
                self.expirationDate = textField.text!
            }
        } else if textField == self.dateField {
            if textField.text != nil {
                self.dateBought = textField.text!
            }
        }
    }
    
    // Called when we unwind from the ChooseThreadViewController
    @IBAction func unwindToImagePicker(segue: UIStoryboardSegue) {
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
