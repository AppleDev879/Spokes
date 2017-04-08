//
//  UserViewController.swift
//  Spokes
//
//  Created by Andrew Barrett on 1/13/17.
//  Copyright © 2017 Andrew Barrett. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class UserViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    let sizes = ["Small", "Medium", "Large"]
    var firebaseRef: FIRDatabaseReference!
    
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var bikePicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firebaseRef = FIRDatabase.database().reference()
        self.createButton.isEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sizes.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sizes[row]
    }
    
    @IBAction func createButtonPressed(_ sender: Any) {
        var pass = false
        var username = ""
        let message = "Please enter a valid email and password."
        
        if let text = emailField.text {
            if text.contains("@") {
                pass = true
                username = text.substring(to: (text.range(of: "@")?.lowerBound)!)
            }
        }
        if (pass == false) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            FIRAuth.auth()?.createUser(withEmail: emailField.text!, password: passwordField.text!, completion: { (user, error) in
                if let e = error {
                    let alert = UIAlertController(title: "Error", message: e.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    if let user = user {
                        self.firebaseRef.child("users/\(user.uid)").setValue(["username" : username, "bike-size" : self.sizes[self.bikePicker.selectedRow(inComponent: 0)]])
                        self.performSegue(withIdentifier: "showMain", sender: self)
                    }
                }
            })
        }
    }
    
    @IBAction func editingChanged(_ sender: Any) {
        if !(emailField.text ?? "").isEmpty && !(passwordField.text ?? "").isEmpty {
            self.createButton.isEnabled = true
        } else {
            self.createButton.isEnabled = false
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}
