//
//  NetworkClient.swift
//  On The Map
//
//  Created by Ademola Fadumo on 30/05/2023.
//

import Foundation

class NetworkClient {
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case getSession
        case signup
        case getStudentLocations
        case addStudentLocation
        case updateStudentLocation(String)
        case getAStudentLocation(String)
        
        var stringValue: String {
            switch self {
            case .getSession:
                return Endpoints.base + "/session"
            case .signup:
                return "https://auth.udacity.com/sign-up?next=https://learn.udacity.com"
            case .getStudentLocations:
                return Endpoints.base + "/StudentLocation?limit=100&order=-updatedAt"
            case .addStudentLocation:
                return Endpoints.base + "/StudentLocation"
            case .updateStudentLocation(let objectId):
                return Endpoints.base + "/StudentLocation/\(objectId)"
            case .getAStudentLocation(let uniqueKey):
                return Endpoints.base + "/StudentLocation?uniqueKey=\(uniqueKey)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func updateStudentLocation(id studentObjectId: String, completion: @escaping (Bool, Error?) -> Void) {
        self.put(url: Endpoints.updateStudentLocation(studentObjectId).url, body: AddStudentLocationRequest(uniqueKey: "001RET", firstName: "Patrick", lastName: "Mahomes", mapString: "", mediaURL: "", latitude: 1.0, longitude: 1.0), response: UpdateStudentLocationResponse.self) { response, error in
            if let response = response {
                completion(response.updatedAt.isEmpty != true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func addStudentLocation(firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, completion: @escaping (Bool, Error?) -> Void) {
        self.post(url: Endpoints.addStudentLocation.url, body: AddStudentLocationRequest(uniqueKey: "001RET", firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude), response: AddStudentLocationResponse.self) { response, error in
            if let response = response {
                print(response)
                completion(response.objectID.isEmpty != true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func getStudentLocations(completion: @escaping ([StudentLocation], Error?) -> Void) {
        self.get(url: Endpoints.getStudentLocations.url, response: StudentLocationResultResponse.self) { response, error in
            if let response = response {
                completion(response.results, error)
            } else {
                completion([], error)
            }
        }
    }
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        self.post(url: self.Endpoints.getSession.url, parseUdacitySecurity: true, body: LoginRequest(udacity: UdacityLogin(username: username, password: password)), response: LoginResponse.self) { response, error in
            if let response = response {
                print(response.account)
                completion(response.account.registered, error)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func logout() {
        var request = URLRequest(url: Endpoints.getSession.url)
        
        request.httpMethod = "DELETE"
        
        var xsrfCookie: HTTPCookie? = nil
        
        let sharedCookieStorage = HTTPCookieStorage.shared
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            
            let newData = self.parseToUdacityData(data)
            print(String(data: newData, encoding: .utf8)!)
        }
        
        task.resume()
    }
    
    @discardableResult private class func get<ResponseType: Decodable>(url: URL, parseUdacitySecurity: Bool = false, response: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            
            var newData = data
            
            if parseUdacitySecurity {
                newData = self.parseToUdacityData(data)
            }
            
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: newData)
                    
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        
        task.resume()
        return task
    }
    
    @discardableResult private class func post<RequestType: Encodable, ResponseType: Decodable>(url: URL, parseUdacitySecurity: Bool = false, body: RequestType, response: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            
            var newData = data
            
            if parseUdacitySecurity {
                newData = self.parseToUdacityData(data)
            }
            
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                print(error)
                
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: newData)
                    
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        
        task.resume()
        return task
    }
    
    @discardableResult private class func put<RequestType: Encodable, ResponseType: Decodable>(url: URL, parseUdacitySecurity: Bool = false, body: RequestType, response: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            
            var newData = data
            
            if parseUdacitySecurity {
                newData = self.parseToUdacityData(data)
            }
            
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                print(error)
                
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: newData)
                    
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        
        task.resume()
        return task
    }
    
    // Data From Udacity is masked with 4 characters before the actual json response
    // For added security so you need to skip the first 4 characters for the json response
    // to be valid
    private class func parseToUdacityData(_ data: Data) -> Data {
        let parsedUdacitySecurityData = 5..<data.count
        let newData = data.subdata(in: parsedUdacitySecurityData)
        
        return newData
    }
}
