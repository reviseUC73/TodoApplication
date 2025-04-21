//
//  APIClient.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 18/4/2568 BE.
//

import Foundation

// MARK: - Date Formatter Utility
enum AppDateFormatter {
    // รองรับเศษส่วนวินาที
    static let iso8601Full: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    
    // รองรับไม่มีเศษส่วนวินาที
    static let iso8601Basic: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()
    
    static func parseISO8601Date(_ dateString: String) -> Date? {
        if let date = iso8601Full.date(from: dateString) {
            return date
        }
        return iso8601Basic.date(from: dateString)
    }
}

enum APIError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case invalidData
    case decodingFailed(Error)
    case serverError(statusCode: Int, message: String?)
    case unauthorized
    case networkError
    case badRequest(message: String?)
    case notFound
    case notModified // เพิ่มสำหรับ 304 responses
}

protocol APIClientProtocol {
    func request<T: Decodable>(endpoint: Endpoint, completion: @escaping (Result<T, APIError>) -> Void)
    func requestFresh<T: Decodable>(endpoint: Endpoint, completion: @escaping (Result<T, APIError>) -> Void)
    func clearCache()
}

protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
    var requiresAuthentication: Bool { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

class APIClient: APIClientProtocol {
    static let shared = APIClient()
    private let session: URLSession
    private let jsonDecoder: JSONDecoder
    
    // เพิ่ม cache สำหรับเก็บข้อมูลล่าสุด
    private var cachedResponses: [String: (data: Data, timestamp: Date)] = [:]
    
    private init() {
        // ปรับค่า URLSessionConfiguration เพื่อควบคุมพฤติกรรม cache
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .useProtocolCachePolicy // ใช้ค่าปกติ
        self.session = URLSession(configuration: config)
        self.jsonDecoder = JSONDecoder()
        
        // Configure date decoding strategy for ISO8601 dates
        self.jsonDecoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            if let date = AppDateFormatter.parseISO8601Date(dateString) {
                return date
            }
            
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Cannot decode date: \(dateString)"
            )
        }
    }
    
    func request<T: Decodable>(endpoint: Endpoint, completion: @escaping (Result<T, APIError>) -> Void) {
        // Check if token needs refresh before making authenticated call
        if endpoint.requiresAuthentication && !TokenManager.shared.isTokenValid() {
            refreshToken { [weak self] result in
                switch result {
                case .success:
                    // Retry the original request with fresh token
                    self?.request(endpoint: endpoint, completion: completion)
                case .failure:
                    // Token refresh failed, redirect to login
                    completion(.failure(.unauthorized))
                    DispatchQueue.main.async {
                        AppRouter.shared.navigateToLogin()
                    }
                }
            }
            return
        }
        
        // สร้าง cache key จาก endpoint
        let cacheKey = "\(endpoint.baseURL.absoluteString)\(endpoint.path)-\(endpoint.method.rawValue)"
        
        // Create URL request
        guard let urlRequest = createURLRequest(for: endpoint, ignoreCache: false) else {
            completion(.failure(.invalidURL))
            return
        }
        
        // Execute request
        let task = session.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                if (error as NSError).domain == NSURLErrorDomain {
                    completion(.failure(.networkError))
                } else {
                    completion(.failure(.requestFailed(error)))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            // Handle HTTP status codes
            switch httpResponse.statusCode {
            case 200...299: // Success
                guard let data = data else {
                    completion(.failure(.invalidData))
                    return
                }
                
                // Cache the response for future 304 responses
                self.cachedResponses[cacheKey] = (data: data, timestamp: Date())
                
                do {
                    let decodedObject = try self.jsonDecoder.decode(T.self, from: data)
                    completion(.success(decodedObject))
                } catch {
                    print("Decoding error: \(error)")
                    completion(.failure(.decodingFailed(error)))
                }
                
            case 304: // Not Modified - use cached data
                if let cachedData = self.cachedResponses[cacheKey]?.data {
                    do {
                        let decodedObject = try self.jsonDecoder.decode(T.self, from: cachedData)
                        completion(.success(decodedObject))
                    } catch {
                        completion(.failure(.decodingFailed(error)))
                    }
                } else {
                    // ถ้าไม่มี cache ให้ลองส่งคำขอใหม่โดยบังคับไม่ใช้ cache
                    if let freshRequest = self.createURLRequest(for: endpoint, ignoreCache: true) {
                        let freshTask = self.session.dataTask(with: freshRequest) { data, response, error in
                            // ดึงข้อมูลใหม่โดยไม่ใช้ cache
                            self.handleAPIResponse(data: data, response: response, error: error, completion: completion)
                        }
                        freshTask.resume()
                    } else {
                        completion(.failure(.invalidData))
                    }
                }
                
            case 400: // Bad Request
                self.handleErrorResponse(data: data, statusCode: httpResponse.statusCode, completion: completion)
                
            case 401: // Unauthorized
                completion(.failure(.unauthorized))
                DispatchQueue.main.async {
                    AppRouter.shared.navigateToLogin()
                }
                
            case 404: // Not Found
                completion(.failure(.notFound))
                
            case 500...599: // Server Error
                self.handleErrorResponse(data: data, statusCode: httpResponse.statusCode, completion: completion)
                
            default:
                completion(.failure(.serverError(statusCode: httpResponse.statusCode, message: nil)))
            }
        }
        
        task.resume()
    }
    
    // Helper method to handle API response
    private func handleAPIResponse<T: Decodable>(data: Data?, response: URLResponse?, error: Error?, completion: @escaping (Result<T, APIError>) -> Void) {
        if let error = error {
            if (error as NSError).domain == NSURLErrorDomain {
                completion(.failure(.networkError))
            } else {
                completion(.failure(.requestFailed(error)))
            }
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(.invalidResponse))
            return
        }
        
        if httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 {
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decodedObject = try self.jsonDecoder.decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch {
                completion(.failure(.decodingFailed(error)))
            }
        } else {
            self.handleErrorResponse(data: data, statusCode: httpResponse.statusCode, completion: completion)
        }
    }
    
    private func createURLRequest(for endpoint: Endpoint, ignoreCache: Bool = false) -> URLRequest? {
        guard let url = URL(string: endpoint.path, relativeTo: endpoint.baseURL) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        // ถ้าต้องการข้ามการใช้ cache
        if ignoreCache {
            request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        }
        
        // Add headers
        if let headers = endpoint.headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        // Add parameters
        if let parameters = endpoint.parameters {
            if endpoint.method == .get {
                // For GET requests, add parameters as query items
                var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
                components?.queryItems = parameters.map {
                    URLQueryItem(name: $0.key, value: "\($0.value)")
                }
                if let url = components?.url {
                    request.url = url
                }
            } else {
                // For other methods, add parameters as JSON in the body
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: parameters)
                    request.httpBody = jsonData
                    if request.value(forHTTPHeaderField: "Content-Type") == nil {
                        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    }
                } catch {
                    print("Error serializing parameters: \(error)")
                    return nil
                }
            }
        }
        
        return request
    }
    
    private func handleErrorResponse<T: Decodable>(data: Data?, statusCode: Int, completion: @escaping (Result<T, APIError>) -> Void) {
        if let data = data {
            do {
                let errorResponse = try jsonDecoder.decode(ErrorResponse.self, from: data)
                if statusCode >= 500 {
                    completion(.failure(.serverError(statusCode: statusCode, message: errorResponse.message)))
                } else if statusCode == 400 {
                    completion(.failure(.badRequest(message: errorResponse.message)))
                } else {
                    completion(.failure(.serverError(statusCode: statusCode, message: errorResponse.message)))
                }
            } catch {
                completion(.failure(.serverError(statusCode: statusCode, message: nil)))
            }
        } else {
            completion(.failure(.serverError(statusCode: statusCode, message: nil)))
        }
    }
    
    private func refreshToken(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let refreshToken = TokenManager.shared.refreshToken else {
            completion(.failure(APIError.unauthorized))
            return
        }
        
        let endpoint = AuthEndpoint.refreshToken(refreshToken: refreshToken)
        
        request(endpoint: endpoint) { (result: Result<AuthTokenResponse, APIError>) in
            switch result {
            case .success(let response):
                // Update tokens
                TokenManager.shared.storeTokens(
                    accessToken: response.accessToken,
                    refreshToken: response.refreshToken,
                    expiresIn: response.expiresIn,
                    userId: response.user.id
                )
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // เพิ่มเมธอดใหม่สำหรับการบังคับโหลดข้อมูลใหม่
    func requestFresh<T: Decodable>(endpoint: Endpoint, completion: @escaping (Result<T, APIError>) -> Void) {
        // สร้าง URLRequest ที่บังคับให้ไม่ใช้ cache
        guard var urlRequest = createURLRequest(for: endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        // เพิ่ม headers ที่บังคับให้ไม่ใช้ cache
        urlRequest.addValue("no-cache", forHTTPHeaderField: "Cache-Control")
        urlRequest.addValue("no-cache", forHTTPHeaderField: "Pragma")
        urlRequest.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        // ล้าง cache สำหรับ endpoint นี้
        let cacheKey = "\(endpoint.baseURL.absoluteString)\(endpoint.path)-\(endpoint.method.rawValue)"
        cachedResponses.removeValue(forKey: cacheKey)
        
        // ดำเนินการส่งคำขอ
        let task = session.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                if (error as NSError).domain == NSURLErrorDomain {
                    completion(.failure(.networkError))
                } else {
                    completion(.failure(.requestFailed(error)))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            // จัดการกับ status code
            if (200...299).contains(httpResponse.statusCode) {
                guard let data = data else {
                    completion(.failure(.invalidData))
                    return
                }
                
                // บันทึกลงใน cache
                self.cachedResponses[cacheKey] = (data: data, timestamp: Date())
                
                do {
                    let decodedObject = try self.jsonDecoder.decode(T.self, from: data)
                    completion(.success(decodedObject))
                } catch {
                    print("Decoding error: \(error)")
                    completion(.failure(.decodingFailed(error)))
                }
            } else {
                self.handleErrorResponse(data: data, statusCode: httpResponse.statusCode, completion: completion)
            }
        }
        
        task.resume()
    }
    
    // เพิ่มเมธอดสำหรับล้าง cache ทั้งหมด
    func clearCache() {
        cachedResponses.removeAll()
    }
}
