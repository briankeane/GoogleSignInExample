//
//  ViewController.swift
//  GoogleSignInExample
//
//  Created by Brian Keane on 11/21/20.
//

import UIKit
import GoogleSignIn

class ViewController: UIViewController {

  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var signOutButton: UIButton!
  @IBOutlet weak var disconnectButton: UIButton!
  @IBOutlet weak var signInButton: GIDSignInButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    GIDSignIn.sharedInstance()?.presentingViewController = self
    
    // automatically signs the user in if they had an active session
    // when they last stopped using the app.  If you want it to look super
    // pro you probably want to do something like this in your app delegate
    // instead:
    // https://stackoverflow.com/questions/35380216/i-implemented-a-google-sign-in-in-ios-app-now-how-can-i-verify-if-user-is-logg
    //
    // that way this view controller is never shown if the user is already
    // signed in.
    GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    
    
    // Watch for the "ToggleAuthUINotification" event that is broadcast from the
    // AppDelegate when someone signs in or out.  When that happens, give them
    // the "receiveToggleAuthUINotification" function below.
    NotificationCenter.default.addObserver(self,
        selector: #selector(ViewController.receiveToggleAuthUINotification(_:)),
        name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
        object: nil)
    
    statusLabel.text = "Initialized Swift App..."
    setUIVisibilities()
  }
  
  @IBAction func signOutButtonTapped(_ sender: Any) {
    GIDSignIn.sharedInstance()?.signOut()
    statusLabel.text = "Signed Out."
    setUIVisibilities()
  }
  
  @IBAction func disconnectButtonTapped(_ sender: Any) {
    GIDSignIn.sharedInstance()?.disconnect()
    statusLabel.text = "Disconnecting..."
  }
  
  func setUIVisibilities() {
    // IF the user is currently signed in, show the disconnect buttons
    if let _ = GIDSignIn.sharedInstance()?.currentUser?.authentication {
      signInButton.isHidden = true
      signOutButton.isHidden = false
      disconnectButton.isHidden = false
    } else {
      signInButton.isHidden = false
      signOutButton.isHidden = true
      disconnectButton.isHidden = true
      statusLabel.text = "Google Sign In\niOS Demo"
    }
  }
  
  @objc func receiveToggleAuthUINotification(_ notification: NSNotification) {
    // Make sure it's the right notification
    if notification.name.rawValue == "ToggleAuthUINotification" {
      self.setUIVisibilities()
      
      if notification.userInfo != nil {
        guard let userInfo = notification.userInfo as? [String:String] else { return }
        self.statusLabel.text = userInfo["statusText"]!
      }
    }
  }
  
  // If you're "watching" for a notification, you want to delete the "watcher"
  // so that you don't get a memory leak
  deinit {
    NotificationCenter.default.removeObserver(self,
        name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
        object: nil)
  }


  
}

