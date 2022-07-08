//
//  ProiectApp.swift
//  Proiect
//
//  Created by m1 on 07/07/2022.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate
{
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool
    {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate
{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        print("Notification received with identifier \(notification.request.identifier)")
        completionHandler([.banner, .sound])
    }
}

@main
struct ProiectApp: App {
    @StateObject private var dataController = DataController()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
