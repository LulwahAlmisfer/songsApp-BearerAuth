//
//  HttpClient.swift
//  YT-Vapor-iOS-App
//
//  Created by Mikaela Caron on 10/19/21.
//

import Foundation

enum HttpMethods: String {
    case POST, GET, PUT, DELETE
}

enum MIMEType: String {
    case JSON = "application/json"
}

enum HttpHeaders: String {
    case contentType = "Content-Type"
    case authorization = "Authorization"
}

enum HttpError: Error {
    case badURL, badResponse, errorDecodingData, invalidURL
}

class HttpClient {
    private init() { }
    
    static let shared = HttpClient()
    
    func fetch<T: Codable>(url: URL) async throws -> [T] {
       let token =  Keychain.load(key: Auth.keychainKey)
    
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HttpMethods.GET.rawValue
        urlRequest.addValue(MIMEType.JSON.rawValue,forHTTPHeaderField: HttpHeaders.contentType.rawValue)
        urlRequest.addValue("Bearer \(token ?? "")", forHTTPHeaderField: HttpHeaders.authorization.rawValue)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            print(response)
            throw HttpError.badResponse
        }
        
        guard let object = try? JSONDecoder().decode([T].self, from: data) else {
            throw HttpError.errorDecodingData
        }
        return object
    }
    
    
    func sendData<T: Codable>(to url: URL, object: T, httpMethod: String) async throws {
        let token =  Keychain.load(key: Auth.keychainKey)
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.addValue(MIMEType.JSON.rawValue, forHTTPHeaderField: HttpHeaders.contentType.rawValue)
        request.addValue("Bearer \(token ?? "")", forHTTPHeaderField: HttpHeaders.authorization.rawValue)
        request.httpBody = try? JSONEncoder().encode(object)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 204 else {
            throw HttpError.badResponse
        }
    }
}
