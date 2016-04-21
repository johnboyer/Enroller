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
    
    private var applicants = [Applicant]()
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
    
    private func initializeApplicants(users: [[String: AnyObject]]) {
        
        for user in users {
            do {
                let applicant = try Applicant(dictionary: user)
                applicants.append(applicant)
            } catch {
                print("JSON error: \(error)")
            }
        }
        
         DDLogDebug("Finished initializing applicants: \(applicants)")
    }
    
    private func initializeApplicants() {
        let baseUri = "http://jsonplaceholder.typicode.com"
        let path = "/users"
        
        let url = NSURL(string: baseUri + path)
        let request = NSURLRequest(URL: url!)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        DDLogInfo("Initializing applicants")
        let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            
            if(error != nil) {
                DDLogError("Error fetching applications from server: \(error)")
            } else {
                
                do {
                    let users = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! [[String: AnyObject]]
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.initializeApplicants(users)
                    })
                    
                }  catch  {
                    print("JSON error: \(error)")
                    
                }
            }
            
        })
        
        // do whatever you need with the task e.g. run
        task.resume()
        
    }
    
    private func initializeRoster() throws {
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
            initializeApplicants()
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
    
    /// Finds student with given email
    public func findStudent(email: String) -> Student? {
        for student in students {
            if student.email == email {
                return student
            }
        }
        
        return nil
    }
    
    /// Withdraws a student
    public func withdraw(student: Student) -> Bool {
        
        let removed: Bool
        let index = students.indexOf(student);
        if (index != nil) {
            students.removeAtIndex(index!);
            removed = true
            DDLogInfo("\(student.email) withdrawn")
            DDLogInfo("Withdrawn: \(student)")
            
        }
        else {
            DDLogWarn("\(student.email) not enrolled")
            removed = false
        }
        
        return removed
    }
    
}