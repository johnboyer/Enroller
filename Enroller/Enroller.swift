//
//  Enroller.swift
//  Enroller
//
//
/*
	Created by John Boyer on 4/17/16.
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

/// JSONError type
enum JSONError: ErrorType {
    /// Key not found
    case KeyNotFound(String)
    case FileReadFailure
}

/// http://stackoverflow.com/a/24318861/314897
func dispatchAfter(delay:Double, closure:()->()) {
    let delta = Int64(delay * Double(NSEC_PER_SEC))
    let when = dispatch_time(DISPATCH_TIME_NOW, delta)
    dispatch_after(when, dispatch_get_main_queue(), closure)
}