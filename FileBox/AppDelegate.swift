//
//  AppDelegate.swift
//  FileBox
//
//  Created by Mikhail Lazarev on 14.07.2020.
//  Copyright © 2020 Mikhail Lazarev. All rights reserved.
//

import AuthenticationServices
import KeychainAccess
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        loadConfig()

        let appleIDProvider = ASAuthorizationAppleIDProvider()

        let keychain = Keychain(service: "com.dtexperts.filebox")
        let userId = try? keychain.getString("userId")

        if let userId = userId {
            appleIDProvider.getCredentialState(forUserID: userId) { credentialState, _ in
                switch credentialState {
                case .authorized:
                    let authService = AuthService.auth

                    if authService.isSignIn {
                        self.swithToMainSB()

                    } else {
                        self.switchToLoginSB()
                    }
                // The Apple ID credential is valid.
                case .revoked, .notFound:
                    // The Apple ID credential is either revoked or was not found, so show the sign-in UI.

                    self.switchToLoginSB()

                default:
                    break
                }
            }
        } else {
            self.switchToLoginSB()
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func switchToLoginSB() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let loginController = storyboard.instantiateViewController(withIdentifier: "LoginNavigationController")
            self.window?.rootViewController = loginController
        }
    }

    func swithToMainSB() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainController = storyboard.instantiateViewController(withIdentifier: "MainNavController") as! UINavigationController

            self.window?.rootViewController = mainController
        }
    }
}
