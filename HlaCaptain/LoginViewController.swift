//
//  LoginViewController.swift
//  HlaCaptain
//
//  Created by IT-aswaqqnet on 1/9/18.
//  Copyright © 2018 Aswaqqnet.com. All rights reserved.
//


import UIKit
import GooglePlaces

import GoogleMaps
import Firebase

import FirebaseDatabase
import FirebaseAuth

import GeoFire

import AVFoundation
import AudioToolbox
import UserNotifications


class LoginViewController: UIViewController, UITextFieldDelegate{

    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    
    
    @IBAction func LoginButton(_ sender: UIButton) {
        
        let email1 = username.text
        let pwd1 = password.text
        
        Auth.auth().signIn(withEmail: email1!, password: pwd1!, completion: { (user, error) in
            if error != nil {
                self.displayAlert(title: "Error", message: error!.localizedDescription)
            } else {
                
                //self.displayAlert(title: "Success", message: "Login in success")
                
                self.newPage1()
            }
        })
        
        
        
    }
    
    
    func displayAlert(title:String, message:String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.username.delegate = self
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let key = Auth.auth().currentUser?.uid
        
        if((key) != nil)
        {
            newPage1()
        }
        else
        {
            print("LOGIN Not Present")
        }
        

    }
    
    func newPage1()
    {
        performSegue(withIdentifier: "LoginToMain", sender: self)
        print("LOGIN Present")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "LoginToMain")
        {
            print("Inside over ride func")
            let nn = segue.destination as! UINavigationController
        }
        
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

}
