//
//  AppDelegate.swift
//  MobileTapInteractive
//
//  Created by Админ on 05.07.2022.
//  ХВ! ВВ!

import UIKit
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.ambient, mode: .moviePlayback, options: [.mixWithOthers])
        }
        catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        
        let mainViewController = MainViewController()
        
        window?.rootViewController = mainViewController
        
        window?.makeKeyAndVisible()
        
        return true
    }

}

