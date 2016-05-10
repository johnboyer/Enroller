//
//  School.swift
//  Enroller
//
//
/*
	Created by John Boyer on 4/15/16.
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
import CocoaLumberjack


/**
  School API class for managing courses, students, and applicants.
  - Author: John Boyer
  - Date: Apr 15, 2016
  - Version: 1.0
  - Since: 1.0
*/
public class School {
    
    /// School Name
    private let name = "Swift University"
    /// List of applicants
    private var applicants = [Applicant]()
    /// List of students
    private var students = [Student]()
    /// Course catalog, set is private
    private(set) var catalog = [Course]()
    
    //MARK: Private methods
    
    /// Reads a JSON file 
    private func readJSONFile(fileName: String) -> AnyObject? {
        let url = NSBundle.mainBundle().URLForResource(fileName, withExtension: "json")
        let data = NSData(contentsOfURL: url!)
        //Note: JSONObjectWithData(...) has a known memory leak, may want to 
        //consider using a third pary library
        return try? NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
    }
    
    /// Adds dictionary of users to the applications array
    private func addApplicants(users: [[String: AnyObject]]) {
        
        for user in users {
            do {
                let applicant = try Applicant(dictionary: user)
                applicants.append(applicant)
            } catch {
                //`error` is a local constant
                DDLogError("JSON error: \(error)")
            }
        }
        
         DDLogDebug("Finished initializing applicants: \(applicants)")
    }
    
    /// Adds users fetched from a web service to the application array
    private func initializeApplicants() {
        let baseUri = "http://jsonplaceholder.typicode.com"
        let path = "/users"
        
        let url = NSURL(string: baseUri + path)
        let request = NSURLRequest(URL: url!)
        //Note: Using an ephermeral session configuration to avoid a memory leak
        //caused by using the default session configuration
        //http://footle.org/2015/10/10/fixing-a-swift-memory-leak
        let config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        DDLogInfo("Initializing applicants")
        let task = session.dataTaskWithRequest(request, completionHandler: {
            //Prevent memory leak by creating a capture list for self, without
            //the capture list, we have a memory leak here.
            [unowned self] (data, response, error) in
            
            if(error != nil) {
                DDLogError("Error fetching applications from server: \(error)")
            } else {
                
                do {
                    //Since we know that the JSON is a dictionary of string keys
                    //we're forcing the downcast to [[String: AnyObject]] using
                    //as! type cast operator
                    let users = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! [[String: AnyObject]]
                    self.addApplicants(users)
                    
                }  catch  {
                    //`error` is local constant
                    DDLogError("JSON error: \(error)")
                    
                }
            }
            
        })
        
        // do whatever you need with the task e.g. run
        task.resume()
        
    }
    
    /// Initializes the roster array
    private func initializeRoster() throws {
        DDLogInfo("Initializing student roster")
        
        //Exit if there's a problem reading the file
        guard let json = readJSONFile("students") as? [String: AnyObject] else {
            throw JSONError.FileReadFailure
        }
        
        //Throw an error if there's no key for students
        guard let roster = json["students"] as? [[String: AnyObject]] else {
            throw JSONError.KeyNotFound("students")
        }
        
        //Build the list of students
        for student:[String: AnyObject] in roster {
            let aStudent = try Student(dictionary: student)
            students.append(aStudent)
        }
        
        DDLogDebug("Student Roster: \(students)")
    }
    
    /// Initializes the catalog array
    private func initializeCatalog() throws {
        
        DDLogInfo("Initializing course catalog")
        guard let json = readJSONFile("courses") else {
           throw JSONError.FileReadFailure
        }
        
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
    /// Init method
    public init() {
        
        do {
            try initializeCatalog()
            try initializeRoster()
        } catch JSONError.KeyNotFound(let key) {
            DDLogError("`\(key)` JSON key not found")
        } catch let unknown {
            DDLogError("\(unknown) error occurred")
        }
        
        dispatchAfter(2.0, closure: { [unowned self] in
            self.initializeApplicants()
            DDLogInfo("Finished initializing school")
        })
        
    }
    
    /**
      Enrolls the given student.
      - Parameter student: The student to enroll
      - Returns: A boolean value of `true` if the student was enrolled;
                 otherwise, `false`.
    */
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
    
    /**
       Finds the course with give code.
       - Parameter code: The course code
       - Returns: A course object or `nil` if not found.
    */
    public func findCourse(code: String) -> Course? {
        for course in catalog {
            if course.code == code {
                return course
            }
        }
        
        return nil
    }
    
    /**
       Finds a student with the given email address.
       - Parameter email: The student's email
       - Returns: A student object or `nil` if not found.
    */
    public func findStudent(email: String) -> Student? {
        for student in students {
            if student.email == email {
                return student
            }
        }
        
        return nil
    }
    
    /**
      Withdraws the give student.
      - Parameter student: The student to withdraw
      - Returns: A boolean value of `true` if the student was withdrawn; 
                 otherwise, `false`.
    */
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