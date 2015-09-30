//
//  ApiWorking.swift
//  AroundTheWorld
//
//  Created by Ky Nguyen on 9/25/15.
//  Copyright © 2015 Ky Nguyen. All rights reserved.
//

import Foundation

class ApiWorking {
    
    static func get(url: String, completeAction: [AnyObject] -> ()) {
    
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            
            let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)

            if let data = strData!.dataUsingEncoding(NSUTF8StringEncoding) {
                
                do{
                    
                    if let array = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)  as? [AnyObject] {
                        
                        completeAction(array)
                    }
                }
                catch {
                    
                    print("error")
                    //handle errors here
                    
                }
            }

        }
     
        task.resume()
    }
    
}
