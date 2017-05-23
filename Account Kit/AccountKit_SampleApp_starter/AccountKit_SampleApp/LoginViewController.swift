// Copyright (c) 2014-present, Facebook, Inc. All rights reserved.
//
// You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
// copy, modify, and distribute this software in source code or binary form for use
// in connection with the web services and APIs provided by Facebook.
//
// As with any software that integrates with the Facebook platform, your use of
// this software is subject to the Facebook Developer Principles and Policies
// [http://developers.facebook.com/policy/]. This copyright notice shall be
// included in all copies or substantial portions of the software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit
import AccountKit
import FBSDKCoreKit
import FBSDKLoginKit

// MARK: - LoginViewController: UIViewController

final class LoginViewController: UIViewController {

    // MARK: Properties
    fileprivate var accountKit = AKFAccountKit(responseType: .accessToken)
    fileprivate var dataEntryViewController: AKFViewController? = nil
    fileprivate var showAccountOnAppear = false
    // TODO: Declare and initialize showAccountOnAppear
    // TODO: Declare and initialize dataEntryViewController
    
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var surfConnectLabel: UILabel!
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAccountOnAppear = accountKit.currentAccessToken !=  nil
        dataEntryViewController = accountKit.viewControllerForLoginResume() as? AKFViewController
     // TODO: Set the value of showAccountOnAppear
     // TODO: Set the value of dataEntryViewController
    
        facebookButton.titleLabel?.addTextSpacing(2.0)
        surfConnectLabel.addTextSpacing(4.0)
        
        //Facebook Login
        let loginButton = FBSDKLoginButton()
        loginButton.center = view.center
        loginButton.delegate = self
        view.addSubview(loginButton)
        
        if((FBSDKAccessToken.current()) != nil){
            presentWithSegueIdentifier("showAccount", animated: false)
        }
        
        loginButton.readPermissions = ["public_profile"]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if showAccountOnAppear {
            showAccountOnAppear = false
            presentWithSegueIdentifier("showAccount", animated: animated)
        }else if let viewController = dataEntryViewController {
            if let viewController = viewController as? UIViewController {
                present(viewController, animated: animated, completion:  nil)
                dataEntryViewController = nil
            }
        }
     // TODO: If showAccountOnAppear is true, present the AccountViewController
     
     // TODO: If showAccountOnAppear is false, prepare and present the
     //       dataEntryViewController
    
        self.navigationController?.isNavigationBarHidden = true
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: Actions
    
    @IBAction func loginWithPhone(_ sender: AnyObject){
        if let viewController = accountKit.viewControllerForPhoneLogin() as? AKFViewController {
            prepareDataEntryViewController(viewController)
            if let viewController = viewController as? UIViewController {
                present(viewController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func loginWithEmail(_ sender: AnyObject){
        if let viewController = accountKit.viewControllerForEmailLogin() as? AKFViewController {
            prepareDataEntryViewController(viewController)
            if let viewController = viewController as? UIViewController {
                present(viewController, animated: true, completion: nil)
            }
        }
    }
    // TODO: Add the IBAction, loginWithPhone(_ sender: )
    // TODO: Add the IBAction, loginWithEmail(_ sender: )
    

    // MARK: Helper Methods
    func prepareDataEntryViewController(_ viewController: AKFViewController){
        viewController.delegate = self;
        viewController.uiManager = AKFSkinManager.init(skinType: .classic, primaryColor: UIColor.seaGreen())
    }
    
    fileprivate func presentWithSegueIdentifier(_ segueIdentifier: String, animated: Bool){
        if animated {
            performSegue(withIdentifier: segueIdentifier, sender: nil)
        }else{
            UIView.performWithoutAnimation {
                self.performSegue(withIdentifier: segueIdentifier, sender: nil)
            }
        }
    }
    
    // TODO: Add the helper method, prepareDataEntryViewController
    // TODO: Add the helper method, presentWithSegueIdentifier
   
}

// MARK: - LoginViewController: AKFViewControllerDelegate

extension LoginViewController: AKFViewControllerDelegate{
    func viewController(_ viewController: UIViewController!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
        presentWithSegueIdentifier("showAccount", animated: false)
    }
    
    func viewController(_ viewController: UIViewController!, didFailWithError error: Error!) {
        print("\(viewController) did fail with error: \(error)")
    }
}

    // TODO: Add the AKFViewControllerDelegate as an extension

    // TODO: Handle callback on successful login
    // TODO: Handle callback on failed login.


//MARK: - LoginViewController: FBSDKLoginButtonDelegate

extension LoginViewController: FBSDKLoginButtonDelegate{
    /**
     Sent to the delegate when the button was used to logout.
     - Parameter loginButton: The button that was clicked.
     */
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
         
    }

    /**
     Sent to the delegate when the button was used to login.
     - Parameter loginButton: the sender
     - Parameter result: The results of the login
     - Parameter error: The error (if any) from the login
     */
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if let error = error {
            print("Login failed with error: \(error)")
        }
        
        if result.token != nil {
            presentWithSegueIdentifier("showAccount", animated: true)
        }
        
    }

    
}
