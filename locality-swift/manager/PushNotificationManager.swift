//
//  PushNotificationManager.swift
//  locality-swift
//
//  Created by Chelsea Power on 4/5/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

class PushNotificationManager: NSObject {
    
    static let shared = PushNotificationManager()
    
    class func registerForRemoteNotifications(_ application: UIApplication) {
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = UIApplication.shared.delegate as? UNUserNotificationCenterDelegate
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = UIApplication.shared.delegate as? FIRMessagingDelegate
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        NotificationCenter.default.addObserver(shared,
                                               selector: #selector(tokenRefreshNotification),
                                               name: .firInstanceIDTokenRefresh,
                                               object: nil)
    }
    
    func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    
    func connectToFcm() {
        // Won't connect since there is no token
        guard FIRInstanceID.instanceID().token() != nil else {
            return
        }
        
        // Disconnect previous FCM connection if it exists.
        FIRMessaging.messaging().disconnect()
        
        FIRMessaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(error?.localizedDescription ?? "")")
            } else {
                print("Connected to FCM with token: \(String(describing: FIRInstanceID.instanceID().token()))")
                
                //connect to all-devices once
                DispatchQueue.once(block: { () in
                    //register to all devices
                    FIRMessaging.messaging().subscribe(toTopic: K.Push.TopicBase + K.Push.Topic.AllDevices)
                    
                    //TODO: MOVE THESE TO ONCE WE HAVE FIRST LOGGED IN!!!!
                    print("Subscribed to topic \(K.Push.TopicBase + K.Push.Topic.AllDevices)")
                    FIRMessaging.messaging().subscribe(toTopic: K.Push.TopicBase + String(format: K.Push.Topic.UserIdFormat, CurrentUser.shared.uid))
                    print("Subscribed to topic \(K.Push.TopicBase + String(format: K.Push.Topic.UserIdFormat, CurrentUser.shared.uid))")
                })
            }
        }
    }
    
    func disconnectFcm() {
        
        FIRMessaging.messaging().disconnect()
        print("Disconnected from FCM")
    }

}
