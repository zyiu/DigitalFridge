//
//  FridgeHomeViewController.swift
//  DigitalFridge
//
//  Created by Debbie Pao on 11/29/17.
//  Copyright © 2017 Debbie Pao. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class FridgeHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! FridgeTableViewCell
        if let post = getItemFromIndexPath(indexPath: indexPath) {
            cell.nameLabel.text = post.name
            cell.expirationLabel.text = post.expiration
            if let image = loadedImages[post.name] {
                cell.foodImageView.image = image
            }
        }
        return cell
    }

    @IBOutlet weak var itemTableView: UITableView!
    
    var loadedImages: [String: UIImage] = [:]
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "addnewItem", sender: self)
    }
    //    @IBAction func addNewItem(_ sender: UIButton) {
//
//
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemTableView.delegate = self
        itemTableView.dataSource = self
    }
    
    // Remember that this method will be called everytime this view appears.
    override func viewWillAppear(_ animated: Bool) {
        // Reload the tablebview.
        itemTableView.reloadData()
        // Update the data from Firebase
        updateData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateData() {
        getItemsInFridge() { (items) in
            if let items = items {
                clearItems()
                for item in items {
                    addItemtoArray(item: item)
                    if item.imagePath != "" {
                        getDataFromPath(path: item.imagePath, completion: { (data) in
                            if let data = data {
                                if let image = UIImage(data: data) {
                                    self.loadedImages[item.name] = image
                                }
                            }
                        })
                    }
                }
                self.itemTableView.reloadData()
            }
        }
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
