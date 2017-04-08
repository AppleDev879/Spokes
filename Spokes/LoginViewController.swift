//
//  LoginViewController.swift
//  Spokes
//
//  Created by Andrew Barrett on 1/19/17.
//  Copyright © 2017 Andrew Barrett. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        var pass = false
        var email = ""
        let message = "Please enter a valid email and password."
        
        if let text = emailTextField.text {
            if text.contains("@") {
                pass = true
                email = text
            }
        }
        if (pass == false) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            FIRAuth.auth()?.signIn(withEmail: email, password: passwordTextField.text!, completion: { (user, error) in
                if let e = error {
                    let alert = UIAlertController(title: "Error", message: e.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.performSegue(withIdentifier: "showMain", sender: self)
                }
            })
        }
    }
    
    @IBAction func editingChanged(_ sender: Any) {
        if !(emailTextField.text ?? "").isEmpty && !(passwordTextField.text ?? "").isEmpty {
            self.loginButton.isEnabled = true
        } else {
            self.loginButton.isEnabled = false
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
