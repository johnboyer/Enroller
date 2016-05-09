//
//  Student.swift
//  Enroller
//
//
/*
	Created by John Boyer on 4/14/16.
	Copyright © 2016 Rodax Software, Inc. All rights reserved.
 
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

import Foundation

public class Student {
    
    /// Email
    var email: String = "john@example.com"
    /// First Name
    var firstName: String = "John"
    /// Last Name
    var lastName: String = "Doe"
    /// Date enrolled
    var dateEnrolled:NSDate?
    /// Birthday, implicitly unwrapped with !
    var birthday:NSDate!
    /// Date formatter object
    private static let dateFormatter = NSDateFormatter()
    /// Static dispatch token
    private static var dispatchToken = 0;
    
    convenience init(email: String, firstName: String, lastName: String, birthday: String) {
        self.init()
        
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.birthday = Student.dateFormatter.dateFromString(birthday)
    }

    convenience init(dictionary: [String: AnyObject]) throws {

        guard let email = dictionary["email"] as? String else {
            throw JSONError.KeyNotFound("email")
        }
        
        guard let firstName = dictionary["firstName"] as? String else {
            throw JSONError.KeyNotFound("firstName")
        }
        
        guard let lastName = dictionary["lastName"] as? String else {
            throw JSONError.KeyNotFound("lastName")
        }
        
        guard let enrolled = dictionary["dateEnrolled"] as? String else {
            throw JSONError.KeyNotFound("dateEnrolled")
        }
        
        guard let birthday = dictionary["birthday"] as? String else {
            throw JSONError.KeyNotFound("birthday")
        }
        
        self.init(email: email, firstName: firstName, lastName: lastName, birthday: birthday)
        
        self.dateEnrolled = Student.dateFormatter.dateFromString(enrolled)
    }
    
    
    init() {
        Student.initializeDateFormatter()
    }
    
    /// Age returns nil if birthday is nil
    var age: Int? {
        if birthday != nil {
            let calendar = NSCalendar.currentCalendar();
            let birthdayComps = calendar.components(NSCalendarUnit.Year, fromDate: birthday)
            let todayComps = calendar.components(NSCalendarUnit.Year, fromDate: NSDate())
            return todayComps.year - birthdayComps.year;
        }
        else {
            return nil
        }
    }
    
    static func initializeDateFormatter() {
        //Dispatch once code snippet for efficiency
        dispatch_once(&dispatchToken) {
            dateFormatter.lenient = false
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            dateFormatter.timeZone = NSTimeZone(abbreviation: "PDT")
            
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }
}

//As a best practice we're using extensions for CustomStringConvertible,
//CustomDebugStringConvertible, and Equatable protocols

// MARK: - Equatable
extension Student: Equatable {}

public func ==(lhs: Student, rhs: Student) -> Bool {
    return lhs.email == rhs.email;
}


// MARK: - CustomStringConvertible
extension Student: CustomStringConvertible {
    public var description: String {
        return debugDescription;
    }
}

// MARK: - CustomDebugStringConvertible
extension Student: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        Student.dateFormatter.dateFormat = "MMMM d, yyyy"
        
        let clazz = "Student: "
        //Specifying NSDictionary for better formatting
        //Forcing unwrapping with `!`
        let aNull = NSNull()
        let details: NSDictionary = ["firstName": firstName,
                                     "lastName": lastName,
                                     "email": email,
                                     "age": age != nil ? age!.description : aNull,
                                     "birthday": birthday != nil ? Student.dateFormatter.stringFromDate(birthday): aNull,
                                     "dateEnrolled": dateEnrolled != nil ? Student.dateFormatter.stringFromDate(dateEnrolled!): aNull]
        
        return clazz + details.description;
    }
    
}


