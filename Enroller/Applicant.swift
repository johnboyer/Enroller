//
//  Applicant.swift
//  Enroller
//
//
/*
    Created by John Boyer on 4/20/16.
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

public class Applicant {
    
    var address: Address
    var name: String
    var email: String
    var applicantId: Int
    
    init(applicantId: Int, name: String, email: String, address: Address) {
        self.applicantId = applicantId
        self.name = name
        self.email = email
        self.address = address
    }
    
    convenience init(dictionary: [String: AnyObject]) throws {
        guard let email = dictionary["email"] as! String? else {
            throw JSONError.KeyNotFound("email")
        }
        
        guard let applicantId = dictionary["id"] as! Int? else {
            throw JSONError.KeyNotFound("id")
        }
        
        guard let name = dictionary["name"] as! String? else {
            throw JSONError.KeyNotFound("name")
        }
        
        guard let addressDictionary = dictionary["address"] as! [String: AnyObject]? else {
             throw JSONError.KeyNotFound("name")
        }
        
        let address = try Address(dictionary: addressDictionary)
        
        self.init(applicantId: applicantId, name: name, email: email, address: address)
    }
    
}

extension Applicant: CustomStringConvertible {
    public var description: String {
        return debugDescription;
    }
}

extension Applicant: CustomDebugStringConvertible {
    public var debugDescription: String {
        let clazz = "Applicant: "
        let details: NSDictionary = ["applicantId": applicantId,
                                     "name": name,
                                     "email": email]
        return clazz + details.description
    }
}