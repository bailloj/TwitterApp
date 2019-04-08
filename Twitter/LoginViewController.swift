//
//  LoginViewController.swift
//  Twitter
//
//  Created by Jireh Grace Baillo on 3/25/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) { //Once Login page loads up:
        if UserDefaults.standard.bool(forKey: "userLoggedIn") == true { //If user has already logged in (checked userLoggedIn in UserDefaults)
            self.performSegue(withIdentifier: "loginToHome", sender: self) //Go straight to home
        }
    }
    
    @IBAction func onLoginButton(_ sender: Any) { //Action once login button pressed
        let myURL = "https://api.twitter.com/oauth/request_token" // URL to Twitter API Login Authentication
        TwitterAPICaller.client?.login(url: myURL, success: { //If login successful:
            UserDefaults.standard.set(true, forKey: "userLoggedIn") //User Default to remember if user logged in already, set key userLoggedIn to true
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }, failure: { (Error) in //If log in not successful
            print("Could not log in!")
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
