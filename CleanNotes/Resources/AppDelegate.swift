//
//  AppDelegate.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 16/01/25.
//

import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate, FileIdentifier {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("\n[\(fileName)] APP LAUNCH IS SUCCESSFULL")
        FirebaseApp.configure()
        return true
    }
}
