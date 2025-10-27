//
//  ApiManager.swift
//  PruebaTecnicaPase
//
//  Created by Fernando Flores on 23/10/25.
//

import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

final class ApiManager {
    
    static let shared = ApiManager()
    private init() {}
    
    func request<T: Codable>(
        baseUrl: String,
        method: HttpMethod,
        queryItems: [String: String]? = nil,
        headers: [String: String] = [:],
        requestBody: Encodable? = nil,
        responseType: T.Type
    ) async throws -> T {
        
        guard var url = URL(string: baseUrl) else {
            throw GenericError(codigo: "Error-400", error: "URL inválida")
        }
        
        
        if let queryItems = queryItems {
            guard var components = URLComponents(string: baseUrl) else {
                throw GenericError(codigo: "Error-400", error: "URL inválida")
            }
            components.queryItems = queryItems.map { URLQueryItem(name: $0.key, value: $0.value) }
            
            guard let finalURL = components.url else {
                throw GenericError(codigo: "Error-401", error: "Error al construir la URL con parámetros")
            }
            url = finalURL
        }
        
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        headers.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        if let requestBody = requestBody {
            urlRequest.httpBody = try JSONEncoder().encode(requestBody)
        }
        
       
        logNetworkRequest(url: url, method: method, headers: headers, queryItems: queryItems, body: requestBody)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw GenericError(codigo: "", error:  "Respuesta inválida del servidor")
        }
            
            logNetworkResponse(url: url, response: httpResponse, data: data)
            
            guard 200..<300 ~= httpResponse.statusCode else {
                if let apiError = try? JSONDecoder().decode(GenericError.self, from: data) {
                    throw apiError
                } else {
                    let message = String(data: data, encoding: .utf8) ?? "Error desconocido"
                    throw GenericError(codigo: "\(httpResponse.statusCode)", error: "Error en el servidor: \(message)")
                    
                }
            }
            
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw GenericError(codigo: "600", error: "Error al decodificar JSON")
            }
            
        } catch let apiError as GenericError {
            throw apiError
        } catch {
            throw GenericError(codigo: "601", error:  "Error desconocido: \(error.localizedDescription)")
        }
    }
}

// MARK: - Logging Extension
private extension ApiManager {
    
    func logNetworkRequest(url: URL, method: HttpMethod, headers: [String: String], queryItems: [String: String]?, body: Encodable?) {
        print("\n📡 ====== REQUEST ======")
        print("➡️ URL: \(url.absoluteString)")
        print("🧭 Método: \(method.rawValue)")
        
        if let queryItems = queryItems, !queryItems.isEmpty {
            print("🔎 QueryItems:")
            queryItems.forEach { print("   • \($0.key): \($0.value)") }
        }
        if !headers.isEmpty {
            print("🧾 Headers:")
            headers.forEach { print("   '• \($0.key): \($0.value)") }
        }
        if let body = body, let data = try? JSONEncoder().encode(body),
           let jsonString = String(data: data, encoding: .utf8) {
            print("📦 Request Body:\n\(jsonString)")
        } else {
            print("📦 Request Body: vacío")
        }
        print("========================\n")
    }
    
    func logNetworkResponse(url: URL, response: HTTPURLResponse, data: Data) {
        print("\n📥 ====== RESPONSE ======")
        print("⬅️ URL: \(url.absoluteString)")
        print("📶 Status Code: \(response.statusCode)")
        
        if let jsonString = String(data: data, encoding: .utf8), !jsonString.isEmpty {
            print("📦 Response Body:\n\(jsonString)")
        } else {
            print("📦 Response Body: vacío")
        }
        print("========================\n")
    }
}
