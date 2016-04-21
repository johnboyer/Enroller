//
//  AppDelegate.swift
//  Enroller
//
/*
	Created by John Boyer on 4/14/16.
	Copyright © 2016 Rodax Software. All rights reserved.
 
	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at
 
	http://www.apache.org/licenses/LICENSE-2.0
 
	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
 */

import UIKit
import CocoaLumberjack



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private func debug(student: Student) {
        print("Custom debugDescription:")
        print(student.debugDescription);
        print()
        
        print("stdlib dump method:")
        /// Dump the entire object to the output stream
        dump(student)
        print()
        
        print("stdlib debugPrint method:")
        debugPrint(student);
    }
    
    func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {

        //Configure CocoaLumberjack
        let logger = DDTTYLogger.sharedInstance()
        logger.logFormatter = CustomDDLogFormatter()
        DDLog.addLogger(logger) // TTY = Xcode console
        DDLog.addLogger(DDASLLogger.sharedInstance()) // ASL = Apple System Logs
        
        let fileLogger: DDFileLogger = DDFileLogger() // File Logger
        fileLogger.rollingFrequency = 60*60*24  // 24 hours
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.addLogger(fileLogger)
        
        DDLogInfo("Logging framework initialized")
        return true
    }


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        DDLogInfo("App launched")
        
        //1) Initialize School object
        DDLogInfo("Instantiate the School object")
        let school = School()
        
        //2 Enroll a student
//        aStudent.firstName = "Alex"
//        aStudent.lastName = "Brown"
//        aStudent.email = "alex@example.com"
//        
//        let components = NSDateComponents()
//        components.day = 4
//        components.month = 4;
//        components.year = 1998
//
//        let calendar = NSCalendar.currentCalendar();
//        aStudent.birthday = calendar.dateFromComponents(components)
        
        let alex = Student(email: "alex@example.com",
                           firstName: "Alex",
                           lastName: "Brown",
                           birthday: "1998-04-04")
        
        school.enroll(alex)
        
        //3) Withdraw a student

        let email = "jennifer@example.com"
        let jennifer = school.findStudent(email)
        if jennifer != nil {
            school.withdraw(jennifer!)
        } else {
            DDLogWarn("`\(email)` not found")
        }
        
            
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

