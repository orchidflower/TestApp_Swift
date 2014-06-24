// 
//  ViewController.swift
//  TestApp
//
//  Created by zhang on 14-6-15.
//  Copyright (c) 2014 zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var textEmail : UITextField
    @IBOutlet var textPassword : UITextField
    @IBOutlet var buttonLogin : UIButton
    @IBOutlet var linkSettings : UILabel
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        println("hello, world!")
        println("TestApp is starting...")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        println("Memory low...")
    }

    @IBAction func onPushButtonLogin(sender : AnyObject) {
        println(sender)
        let email = textEmail.text
        let password = textPassword.text
        
        println("username: \(email), password: \(password)")
    }

}

