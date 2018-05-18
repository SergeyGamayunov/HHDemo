//
//  HHEndpoint.swift
//  HeadsAndHandsDemo
//
//  Created by Сергей Гамаюнов on 18/05/2018.
//  Copyright © 2018 Сергей Гамаюнов. All rights reserved.
//

import Foundation

typealias JSON = [String: Any]
enum HHEndpoint {
    case search(String)

    
    var baseURL: String {
        return "https://itunes.apple.com/"
    }
    
    var path: String {
        switch self {
        case .search: return "search"
        }
    }
    
    var parameters: JSON {
        switch self {
        case .search(let term): return ["term": term]
        }
    }
    
    var queryComponents: [URLQueryItem] {
        var components = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.append(queryItem)
        }
        
        return components
    }
    
    var components: URLComponents {
        var components = URLComponents(string: baseURL)!
        components.path = path
        components.queryItems = queryComponents
        
        return components
    }
    
    var url: URL {
        return URL(string: path, relativeTo: URL(string: baseURL)!)!
    }
}
