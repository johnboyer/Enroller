//
//  Address.swift
//  Enroller
//
//
/*
	Created by John Boyer on 4/24/16.
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

/// Address structure
struct Address {
    
    /// Street number and name
    var street: String
    /// Apt. or ste. no.
    var suite: String?
    /// City
    var city: String
    /// Zipcode
    var zipcode: String
    
    /// Geolocation structure
    struct Geolocation {
        var latitude: Double
        var longitude: Double
    }
    
    /// Geolocation
    var geo: Geolocation
    
    /// Init
    init(street: String, suite: String, city: String, zipcode: String, geo: Geolocation) {
        self.street = street
        self.suite = suite
        self.city = city
        self.zipcode = zipcode
        self.geo = geo
    }
    
    /// Init takes a dictionary
    init(dictionary: [String: AnyObject]) throws {
        
        guard let street = dictionary["street"] as! String? else {
            throw JSONError.KeyNotFound("street")
        }
        
        guard let suite = dictionary["suite"] as! String? else {
            throw JSONError.KeyNotFound("suite")
        }
        
        guard let city = dictionary["city"] as! String? else {
            throw JSONError.KeyNotFound("city")
        }
        
        guard let zipcode = dictionary["zipcode"] as! String? else {
            throw JSONError.KeyNotFound("zipcode")
        }
        
        guard let geoDictionary = dictionary["geo"] as! [String: String]? else {
            throw JSONError.KeyNotFound("geo")
        }
        
        guard let lat = geoDictionary["lat"] else {
             throw JSONError.KeyNotFound("lat")
        }
        
        guard let long = geoDictionary["lng"] else {
            throw JSONError.KeyNotFound("lng")
        }
        
        let geo = Geolocation(latitude: Double(lat)!, longitude: Double(long)!)
        
        self.init(street: street, suite: suite, city: city, zipcode: zipcode, geo: geo)
 
    }
    
}