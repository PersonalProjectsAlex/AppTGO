//
//  AppDelegate.swift
//  Tugo
//
//  Created by Alex on 16/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import FirebaseCore
import SendBirdSDK
import Stripe
import UserNotifications
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Firebase delegate
        FIRApp.configure()
        
        //Sendbird delegate
        SBDMain.initWithApplicationId(K.sendbirdAPI)
    
        //Delegating Stripe
        STPPaymentConfiguration.shared().publishableKey = K.stripePublishableKey
        
        //Enabling our own keyboard
        IQKeyboardManager.sharedManager().enable = true
        
        GIDSignIn.sharedInstance().signOut()
        
        //Facebook delegate
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Initialize sign-in
        GIDSignIn.sharedInstance().clientID = K.googleUserContent
        
        //
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            print("granted: (\(granted)")
        }
        
        Core.shared.callOauth()
        
        
        UNUserNotificationCenter.current().delegate = self
        
        //Setting rootview
        let instance = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.signIn)
        let instanceHost = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.Host.signInhost)
        let codePendient = Singleton.shared.checkisBool(key: K.defaultKeys.Auth.Host.pendingState)
        let incompleteState = Singleton.shared.checkisBool(key: K.defaultKeys.Auth.Host.incompleteState)
        print(instance)
        
        if !instance.isEmpty{
            setNewRootView(K.storyboards.menu, K.Instancecontrollers.Main.mainTabBarController)
        }
        
        if !instance.isEmpty && codePendient{
            setNewRootView(K.storyboards.authHost, K.Instancecontrollers.AuthHost.validateCodeHostController)
        }
        print(incompleteState)
        if !instance.isEmpty && incompleteState{
            setNewRootView(K.storyboards.authHost, K.Instancecontrollers.AuthHost.IncompleteStateController)
        }
        
        if !instance.isEmpty && !instanceHost.isEmpty{
            setNewRootView(K.storyboards.menuHost, K.Instancecontrollers.Main.Host.mainTabBarHostController)
        }
        
        
        
        return true
    }
    
    func setNewRootView(_ storyboard: String, _ identifier:String){
        
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: identifier )
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }

    // MARK: - Facebook/Google handler
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication =  options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
        let annotation = options[UIApplicationOpenURLOptionsKey.annotation]
        
        let googleHandler = GIDSignIn.sharedInstance().handle(
            url,
            sourceApplication: sourceApplication,
            annotation: annotation )
        
        let facebookHandler = FBSDKApplicationDelegate.sharedInstance().application (
            app,
            open: url,
            sourceApplication: sourceApplication,
            annotation: annotation )
        
        return googleHandler || facebookHandler
    }
    
    // MARK: - Google Delegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}
    
    

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
  
  
}
