//
//  ViewController.swift
//  FlashChat
//
//  Created by Dayton on 11/12/20.
//

import UIKit


class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    
    //the time point where we want to hide it is just before the view shows up on screen
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    //this will hide every navigation bar on the screen
    //so, in addition to hiding it, we also need to unhide it and the time point is when we are about to go to the next screen.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        titleLabel.text = ""
        var charIndex = 0.0
        let title = K.appName
        for letter in title{
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
                self.titleLabel.text?.append(letter)
            }
         charIndex += 1
        }
    }
    
    
}
