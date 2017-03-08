//
//  LocalityBaseViewController.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/2/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import FirebaseAuth

class LocalityBaseViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        hideKeyboardOnTouchedOut()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func alertEmailValidate() {
        
        let alert = UIAlertController(title: K.String.Alert.VerifyTitle.localized,
                                      message: K.String.Alert.VerifyMessage.localized,
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        let confirmAction = UIAlertAction(title: K.String.Alert.VerifyButton0.localized,
                                          style: .default) { (action) in
            
            FIRAuth.auth()?.currentUser?.sendEmailVerification(completion: { (error) in
                if error == nil {
                    //Email validation resent
                    alert.dismiss(animated: true, completion: nil)
                }
            })
        }
        
        
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .cancel, handler: nil)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
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
