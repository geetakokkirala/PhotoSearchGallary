//
//  Request.swift
//  PhotoSearchGallary
//
//  Created by Geetha on 25/02/22.
//

import Foundation

protocol Requestable {
    var baseUrl:String {get}
    var path:String {get}
    var params:[String:String] {get}
}

struct Request:Requestable {
    var baseUrl: String
    var path: String
    var params: [String : String]
}

enum ServiceError: Error {
    case failedToCreateRequest
    case dataNotFound
    case parsingError
    case networkNotAvailable
    
}
