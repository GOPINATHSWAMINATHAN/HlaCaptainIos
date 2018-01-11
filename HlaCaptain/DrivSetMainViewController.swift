//
//  DrivSetMainViewController.swift
//  HlaCaptain
//
//  Created by IT-aswaqqnet on 1/8/18.
//  Copyright © 2018 Aswaqqnet.com. All rights reserved.
//

import UIKit
import FirebaseAuth

class DrivSetMainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    func displayAlert(title:String, message:String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    let list = ["Name", "ID", "Logout"]
    
    @IBAction func logout(_ sender: UIButton) {
        
        do {
            try Auth.auth().signOut()
            self.displayAlert(title: "Success", message: "logout success")
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return(list.count)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = list[indexPath.row]
        
        return(cell)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
       
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
