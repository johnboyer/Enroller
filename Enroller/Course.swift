//
//  Course.swift
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

//MARK: - Course class
class Course {
    
    /// Course code
    var code: String?
    /// Title
    var title: String?
    /// Class capacity
    var capacity: Int?
    /// Start time
    var startTime: String = "HH:mm"
    /// Duration
    var duration: Int?
    /// Days offered
    // Su, M, T, W, Th, F, Sa
    var days: [String]?
    /// Credit hours
    var creditHours: Int?
    
    /// Intializer
    init(courseDictionary: [String: AnyObject]) throws {
        
        //Set code
        guard let code = courseDictionary["code"] as? String else {
            throw JSONError.KeyNotFound("code");
        }
        
        self.code = code
        
        //Set title
        guard let title = courseDictionary["title"] as? String else {
            throw JSONError.KeyNotFound("title")
        }
        
        self.title = title
        
        guard let creditHours = courseDictionary["creditHours"] as? Int else {
            throw JSONError.KeyNotFound("creditHours")
        }
        
        self.creditHours = creditHours
        
        guard let startTime = courseDictionary["startTime"] as? String else {
            throw JSONError.KeyNotFound("startTime")
        }
        
        self.startTime = startTime
        
        guard let duration = courseDictionary["duration"] as? Int else {
            throw JSONError.KeyNotFound("duration")
        }
        
        self.duration = duration
        
        guard let days = courseDictionary["days"] as? [String] else {
            throw JSONError.KeyNotFound("days")
        }
        
        self.days = days
        
        guard let capacity = courseDictionary["capacity"] as? Int else {
            throw JSONError.KeyNotFound("capacity")
        }
        
        self.capacity = capacity
        
    }
}

//MARK: - CustomStringConvertible
extension Course: CustomStringConvertible {
    var description: String {
        return debugDescription
    }
}

//MARK: - CustomDebugStringConvertible
extension Course: CustomDebugStringConvertible {
    var debugDescription: String {
        let clazz = "Course: "
        let details = ["code": code!,
                       "title": title!,
                       "startTime": startTime,
                       "duration": duration!,
                       "capacity": capacity!,
                       "days": days!,
                       "creditHours": creditHours!]
        
        
        return clazz + details.description

    }
}
