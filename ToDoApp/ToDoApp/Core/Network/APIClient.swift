//
//  APIClient.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 18/4/2568 BE.
//

import Foundation

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
}

protocol APIClientProtocol {
    func request<T: Decodable>(endpoint: Endpoint, completion: @escaping (Result<T, APIError>) -> Void)
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
    
    private init() {
        self.session = URLSession.shared
        self.jsonDecoder = JSONDecoder()
        
        // Configure date decoding strategy for ISO8601 dates
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        self.jsonDecoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            if let date = dateFormatter.date(from: dateString) {
                return date
            }
            
            // Fallback to standard ISO8601 without fractional seconds
            let fallbackFormatter = ISO8601DateFormatter()
            if let date = fallbackFormatter.date(from: dateString) {
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
        
        // Create URL request
        guard let urlRequest = createURLRequest(for: endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        // Execute request
        let task = session.dataTask(with: urlRequest) { [weak self] data, response, error in
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
                
                do {
                    let decodedObject = try self?.jsonDecoder.decode(T.self, from: data)
                    if let decodedObject = decodedObject {
                        completion(.success(decodedObject))
                    } else {
                        completion(.failure(.invalidData))
                    }
                } catch {
                    print("Decoding error: \(error)")
                    completion(.failure(.decodingFailed(error)))
                }
                
            case 400: // Bad Request
                self?.handleErrorResponse(data: data, statusCode: httpResponse.statusCode, completion: completion)
                
            case 401: // Unauthorized
                completion(.failure(.unauthorized))
                DispatchQueue.main.async {
                    AppRouter.shared.navigateToLogin()
                }
                
            case 404: // Not Found
                completion(.failure(.notFound))
                
            case 500...599: // Server Error
                self?.handleErrorResponse(data: data, statusCode: httpResponse.statusCode, completion: completion)
                
            default:
                completion(.failure(.serverError(statusCode: httpResponse.statusCode, message: nil)))
            }
        }
        
        task.resume()
    }
    
    private func createURLRequest(for endpoint: Endpoint) -> URLRequest? {
        guard let url = URL(string: endpoint.path, relativeTo: endpoint.baseURL) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
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
}
