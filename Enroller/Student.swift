//
//  Student.swift
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

import Foundation

public class Student {
    
    /// Email
    var email: String?
    /// First Name
    var firstName: String?
    /// Last Name
    var lastName: String?
    /// Date enrolled
    var dateEnrolled:NSDate?
    /// Birthday
    var birthday:NSDate?
    /// Date formatter object
    private static let dateFormatter = NSDateFormatter()
    
    convenience init(email: String, firstName: String, lastName: String, birthday: String) {
        self.init()
        
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        
        Student.dateFormatter.dateFormat = "yyyy-MM-dd"
        self.birthday = Student.dateFormatter.dateFromString(birthday)
        
    }

    convenience init(dictionary: [String: AnyObject]) throws {
        self.init()
        
        guard let email = dictionary["email"] as? String else {
            throw JSONError.KeyNotFound("email")
        }
        
        self.email = email;
        
        guard let firstName = dictionary["firstName"] as? String else {
            throw JSONError.KeyNotFound("firstName")
        }
        
        self.firstName = firstName
        
        guard let lastName = dictionary["lastName"] as? String else {
            throw JSONError.KeyNotFound("lastName")
        }
        
        self.lastName = lastName
        
        guard let enrolled = dictionary["dateEnrolled"] as? String else {
            throw JSONError.KeyNotFound("dateEnrolled")
        }
        
        Student.dateFormatter.dateFormat = "yyyy-MM-dd"
        self.dateEnrolled = Student.dateFormatter.dateFromString(enrolled)
     
        guard let birthday = dictionary["birthday"] as? String else {
            throw JSONError.KeyNotFound("birthday")
        }
        
        self.birthday = Student.dateFormatter.dateFromString(birthday)

    }
    
    init() {
        Student.dateFormatter.lenient = false
        Student.dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        Student.dateFormatter.timeZone = NSTimeZone(abbreviation: "PDT")
        
    }
    
    /// Age
    var age: Int {
            let calendar = NSCalendar.currentCalendar();
            let birthdayComps = calendar.components(NSCalendarUnit.Year, fromDate: birthday!)
            let todayComps = calendar.components(NSCalendarUnit.Year, fromDate: NSDate())
            return todayComps.year - birthdayComps.year;
    }
 
}

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
        let aNull = NSNull()
        let details: NSDictionary = ["firstName": firstName != nil ? firstName!: aNull,
                                     "lastName": lastName != nil ? lastName!:aNull,
                                     "email": email != nil ? email!: aNull,
                                     "age": age.description,
                                     "birthday": birthday != nil ? Student.dateFormatter.stringFromDate(birthday!): aNull,
                                     "dateEnrolled": dateEnrolled != nil ? Student.dateFormatter.stringFromDate(dateEnrolled!): aNull]
        
        return clazz + details.description;
    }
    
}


