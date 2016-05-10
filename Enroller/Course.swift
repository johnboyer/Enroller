//
//  Course.swift
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

//MARK: - Course class
/// Course class
public class Course {
    
    /// Course code
    private(set) var code: String
    /// Title
    private(set) var title: String
    /// Class capacity
    private(set) var capacity: Int
    /// Start time
    private(set) var startTime: String = "HH:mm"
    /// Duration
    private(set) var duration: Int
    /// Days offered
    // Su, M, T, W, Th, F, Sa
    private(set) var days: [String]
    /// Credit hours
    private(set) var creditHours: Int
    
    /// Init method
    init(code: String, title: String, creditHours: Int, startTime: String, duration: Int, days: [String], capacity: Int) {
        self.code = code
        self.title = title
        self.creditHours = creditHours
        self.startTime = startTime
        self.duration = duration
        self.days = days
        self.capacity = capacity
    }
    
    /// Convenience intializer takes a course dictionary
    convenience init(courseDictionary: [String: AnyObject]) throws {
        
        guard let code = courseDictionary["code"] as? String else {
            throw JSONError.KeyNotFound("code");
        }

        guard let title = courseDictionary["title"] as? String else {
            throw JSONError.KeyNotFound("title")
        }
        
        guard let creditHours = courseDictionary["creditHours"] as? Int else {
            throw JSONError.KeyNotFound("creditHours")
        }
        
        guard let startTime = courseDictionary["startTime"] as? String else {
            throw JSONError.KeyNotFound("startTime")
        }
    
        guard let duration = courseDictionary["duration"] as? Int else {
            throw JSONError.KeyNotFound("duration")
        }
        
        guard let days = courseDictionary["days"] as? [String] else {
            throw JSONError.KeyNotFound("days")
        }
    
        guard let capacity = courseDictionary["capacity"] as? Int else {
            throw JSONError.KeyNotFound("capacity")
        }
        
        self.init(code: code, title: title, creditHours: creditHours, startTime: startTime, duration: duration, days: days, capacity: capacity);
        
    }
    
}

//As a best practice we're using extensions for CustomStringConvertible and
//CustomDebugStringConvertible protocols

//MARK: - CustomStringConvertible
/// CustomStringConvertible extension class
extension Course: CustomStringConvertible {
    public var description: String {
        return debugDescription
    }
}

//MARK: - CustomDebugStringConvertible
/// CustomDebugStringConvertible extension class
extension Course: CustomDebugStringConvertible {
    public var debugDescription: String {
        let clazz = "Course: "
        let details = ["code": code,
                       "title": title,
                       "startTime": startTime,
                       "duration": duration,
                       "capacity": capacity,
                       "days": days,
                       "creditHours": creditHours]
        
        return clazz + details.description
        
    }
}

//MARK: - Equatable
extension Course: Equatable { }

/// Course ==
public func ==(lhs: Course, rhs: Course) -> Bool {
    return lhs.code == rhs.code
}
