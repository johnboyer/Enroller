//
//  CustomDDLogFormatter.swift
//  Enroller
//
//
/*
	Created by John Boyer on 4/17/16.
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

public class CustomDDLogFormatter: NSObject, DDLogFormatter {
    
    let dateFormmater = NSDateFormatter()
    
    public override init() {
        super.init()
        dateFormmater.dateFormat = "yyyy/MM/dd HH:mm:ss:SSS"
    }
    
    //MARK: - DDLogFormatter
    public func formatLogMessage(logMessage: DDLogMessage!) -> String! {
        
        let logLevel: String
        switch logMessage.flag {
        case DDLogFlag.Error:
            logLevel = "ERROR"
        case DDLogFlag.Warning:
            logLevel = "WARNING"
        case DDLogFlag.Info:
            logLevel = "INFO"
        case DDLogFlag.Debug:
            logLevel = "DEBUG"
        default:
            logLevel = "VERBOSE"
        }
        
        let dt = dateFormmater.stringFromDate(logMessage.timestamp)
        let logMsg = logMessage.message
        let lineNumber = logMessage.line
        let file = logMessage.fileName
        let functionName = logMessage.function
        let threadId = logMessage.threadID

        return "\(dt) [\(threadId)] [\(logLevel)] [\(file):\(lineNumber)]\(functionName) - \(logMsg)"
    }
}
