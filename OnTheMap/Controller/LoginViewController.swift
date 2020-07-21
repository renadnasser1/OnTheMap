//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Renad nasser on 10/07/2020.
//  Copyright © 2020 Renad nasser. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextFiled: UITextField!
    @IBOutlet weak var passwordTextFiled: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set UI proprites
        setUI()
        
    }
    
    //MARK: - UI proprites
    func setUI(){
        passwordTextFiled.isSecureTextEntry = true
    }
    
    
    //    MARK: - Login
    @IBAction func loginClicked(_ sender: Any) {
        let email = "renadnasser22@gmail.com"//emailTextFiled.text
        let password = "r1234567R"//passwordTextFiled.text
        
        if email == "" , password == ""{
            //Alert
            ErrorHandller.showAlert(title:"", message: "Must enter email/passwoard", viewController: self)
        }
        
        
        APICalls.login(username: email, password: password) { (key, error) in
            if key != nil{
                
                self.emailTextFiled.text = ""
                self.passwordTextFiled.text = ""
                //Seque to locations
                self.performSegue(withIdentifier: "locationsSegue", sender: nil)
                
            }else{
                //Alert
                ErrorHandller.showAlert(title:"Login Failed", message: "There was an error performing your login", viewController: self)
                
            }
            
        }
    }
    
    //   MARK: - Sign up via website
    @IBAction func signup(_ sender: Any) {
        UIApplication.shared.open(APICalls.Endpoints.signUp.url, options: [:], completionHandler: nil)
    }
    
    
    
    
}//End Class

