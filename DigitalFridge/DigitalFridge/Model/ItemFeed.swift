//
//  FridgeItems.swift
//  DigitalFridge
//
//  Created by Debbie Pao on 11/29/17.
//  Copyright © 2017 Debbie Pao. All rights reserved.
//

import UIKit
import Foundation
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

var user: String = "";

var itemArray: [FridgeItem] = []

func addItemtoArray(item: FridgeItem) {
    itemArray.append(item)
}

func getItemFromIndexPath(indexPath: IndexPath) -> FridgeItem? {
    return itemArray[indexPath.row]
}

//ADDS NEW ITEM TO FIREBASE
func addItem(itemName: String, expirDate: String, dateBought: String, postImage:UIImage? = nil) {
    print("adding to firebase")
    if itemName == "" || expirDate == "" || dateBought == "" {
        let alertController = UIAlertController(title: "Form Error.", message: "Please fill in form completely.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        //present(alertController, animated: true, completion: nil)
    } else {
        let postDict: [String:AnyObject]
        let dbRef = FIRDatabase.database().reference()
        if let image = postImage {
            let data = UIImageJPEGRepresentation(image, 1.0)
            let path = "Images/\(UUID().uuidString)"
            postDict = ["itemName": itemName as AnyObject,
                                                "expiration": expirDate as AnyObject,
                                                "dateBought": dateBought as AnyObject,
                                                "imagePath": path as AnyObject]
            store(data: data, toPath: path)
        } else {
            postDict = ["itemName": itemName as AnyObject,
                                                "expiration": expirDate as AnyObject,
                                                "dateBought": dateBought as AnyObject,
                                                "imagePath": "" as AnyObject]
        }
        
        if let currentUser = FIRAuth.auth()?.currentUser?.email {
            var arr = currentUser.components(separatedBy: ".")
            user = arr[0]
            let newPostKey = dbRef.child("/" +  user + "/Items/").childByAutoId().key;
            let childUpdates = ["/\(user)/Items/\(newPostKey)": postDict]
            dbRef.updateChildValues(childUpdates);
        }
    }
}

func store(data: Data?, toPath path: String) {
    let storageRef = FIRStorage.storage().reference()
    storageRef.child(path).put(data!, metadata: nil) { (metadata, error) in
        if let error = error {
            print(error)
        }
    }
}

func clearItems() {
    itemArray = []
}

//GET ITEMS FROM FIREBASE FOR EACH USER
func getItemsInFridge(completion: @escaping ([FridgeItem]?) -> Void) {
    let dbRef = FIRDatabase.database().reference()
    if let currentUser = FIRAuth.auth()?.currentUser?.email {
        var arr = currentUser.components(separatedBy: ".")
        user = arr[0]
    }
    var itemArr: [FridgeItem] = []
    dbRef.child("/\(user)/Items").observeSingleEvent(of: .value, with: { snapshot -> Void in
        if snapshot.exists() {
            if let posts = snapshot.value as? [String:AnyObject] {
                for postKey in posts.keys {
                    if let value = posts[postKey]as? [String:AnyObject] {
                        let item: FridgeItem
                        let name = value["itemName"]
                        let expiration = value["expiration"]
                        let dateBought = value["dateBought"]
                        if let imagePath = value["imagePath"] {
                            item = FridgeItem(name: name as! String, expiration: expiration as! String, dateBought: dateBought as! String, imagePath: imagePath as! String)
                        } else {
                            item = FridgeItem(name: name as! String, expiration: expiration as! String, dateBought: dateBought as! String, imagePath: "")
                        }
                        itemArr.append(item)
                    } else {
                        completion(nil)
                    }
                }
                completion(itemArr)
            } else {
                completion(nil)
            }
        } else {
            completion(nil)
        }
    })
}

func getDataFromPath(path: String, completion: @escaping (Data?) -> Void) {
    let storageRef = FIRStorage.storage().reference()
    storageRef.child(path).data(withMaxSize: 5 * 1024 * 1024) { (data, error) in
        if let error = error {
            print(error)
        }
        if let data = data {
            completion(data)
        } else {
            completion(nil)
        }
    }
}


