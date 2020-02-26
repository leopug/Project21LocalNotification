//
//  ViewController.swift
//  Project21LocalNotification
//
//  Created by Ana Caroline de Souza on 25/02/20.
//  Copyright © 2020 Ana e Leo Corp. All rights reserved.
//
import UserNotifications
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain , target: self, action: #selector(scheduleLocal))
        
    }

    @objc func registerLocal(){
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) {
            granted, error in
            if granted {
                print("yayy")
            }else {
                print("D'oh")
            }
        }
        
    }
    
    @objc func scheduleLocal(){
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets tha xiss"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData":"fizzbuzz"]
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 20
        dateComponents.minute = 30
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
  
        var trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        var request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
        
        trigger = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: false)
        
        request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
        
        
    }
    
    func registerCategories(){
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let showNotificationAction = UNNotificationAction(identifier: "show", title: "Tell me more", options: .foreground)
        let remindMeLaterNotificationAction = UNNotificationAction(identifier: "remindMeLater", title: "Remind me later", options: .foreground)
        
        let category = UNNotificationCategory(identifier: "alarm", actions: [showNotificationAction], intentIdentifiers: [])
        let categoryRemindMeLater = UNNotificationCategory(identifier: "alarm", actions: [remindMeLaterNotificationAction], intentIdentifiers: [])
        
        center.setNotificationCategories([category,categoryRemindMeLater])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")
        }
        
        let ac = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        switch response.actionIdentifier {
        case UNNotificationDefaultActionIdentifier:
            //user swipted to unlock
            print("Default identifier")
            ac.title = "Default Called!"
            ac.message = "Default identifier called dude!"
        case "show":
            print("Show more info...")
            ac.title = "Custom Called!!!"
            ac.message = "Custom uhuul identifier called dude!"
        case "remindMeLater":
            print("Show more info...")
            ac.title = "Reminder Called!!!"
            ac.message = "Reminder identifier called dude!"

        default:
            break
        }
        
        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(ac,animated: true)
        
        completionHandler()
    }

}

