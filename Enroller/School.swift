//
//  School.swift
//  Enroller
//
/*
	Created by John Boyer on 4/15/16.
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
import CocoaLumberjack


public class School {
    
    /// School Name
    private let name = "Swift University"
    
    /// List of students
    private var students = [Student]()
    /// Course catalog
    private var catalog = [Course]()
    
    //MARK: Private methods
    private func readJSONFile(fileName: String) throws -> AnyObject {
        let url = NSBundle.mainBundle().URLForResource(fileName, withExtension: "json")
        let data = NSData(contentsOfURL: url!)
        return try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
    }
    
    func initializeRoster() throws {
        DDLogInfo("Initializing student roster")
        
        guard let json = try readJSONFile("students") as? [String: AnyObject] else {
            preconditionFailure("Unable intialize roster")
        }
        
        guard let roster = json["students"] as? [[String: AnyObject]] else {
            throw JSONError.KeyNotFound("students")
        }
        
        for student:[String: AnyObject] in roster {
            let aStudent = try Student(dictionary: student)
            students.append(aStudent)
        }
        
        DDLogDebug("Student Roster: \(students)")
    }
    
    private func initializeCatalog() throws {
        
        DDLogInfo("Initializing course catalog")
        //Need guard clause here...
        let json = try readJSONFile("courses")
        
        assert(json["courses"] != nil, "Courses array is nil")
        //Need guard clause here...
        if let courses = json["courses"] as? [[String: AnyObject]] {
            
            for course:[String: AnyObject] in courses {
                
                let aCourse = try Course(courseDictionary: course)
                catalog.append(aCourse)
            }
            
            DDLogDebug("Course Catalog: \(catalog)")
        }
        
    }
    
    //MARK: Public methods
    public init() {
        
        do {
            try initializeCatalog()
            try initializeRoster()
            DDLogInfo("Finished School initialization")
        } catch JSONError.KeyNotFound(let key) {
            DDLogError("`\(key)` JSON key not found")
        } catch let unknown {
            DDLogError("\(unknown) error occurred")
        }
        
    }
    
    /// Enrolls a student
    public func enroll(student: Student) -> Bool {
        
        let enrolled: Bool
        if !students.contains(student) {
            student.dateEnrolled = NSDate()
            students.append(student);
            enrolled = true
            
            DDLogInfo("\(student.email) enrolled")
            DDLogDebug("Enrollee: \(student)")
        }
            
        else {
            DDLogWarn("\(student.email) already enrolled")
            enrolled = false
        }
        
        return enrolled
    }
    
    /// Withdraws a student
    public func withdraw(student: Student) -> Bool {
        
        let removed: Bool
        let index = students.indexOf(student);
        if (index != nil) {
            students.removeAtIndex(index!);
            removed = true
        }
        else {
            removed = false
        }
        
        return removed
    }
    
}