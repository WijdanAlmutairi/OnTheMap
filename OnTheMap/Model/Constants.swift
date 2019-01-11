//
//  Constants.swift
//  OnTheMap
//
//  Created by MAC on 01/01/2019.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

struct Constants {
    
    
    struct Udacity {
      static let ApiScheme = "https"
      static let ApiHost = "onthemap-api.udacity.com"
      static let ApiPath = "/v1"
    }
    
    struct UdacityParameterKeys {
        static let username = "username"
        static let password = "password"
    }
    
    
    struct UdacityResponseKeys {
        static let session = "session"
        static let sessionID = "id"
        static let userAccount = "account"
        static let userID = "key"
        
    }
    
    
    struct Parse {
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes"
    }
    
    struct ParseParameterKeys {
      static let parseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
      static let RESTAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
      static let studentsMax = "limit"
      static let studentOrder = "order"
        
    }
    
    struct ParseParameterValues {
        static let studentsMaxNumber = "100"
        static let studentChosenOrder = "-updatedAt"
    
    }
}


