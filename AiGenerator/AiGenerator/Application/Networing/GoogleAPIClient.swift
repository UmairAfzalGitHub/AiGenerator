//
//  GoogleAPIClient.swift
//  AiGenerator
//
//  Created by Umair Afzal on 20/09/2025.
//

import Foundation

// MARK: - Request Models
struct GeminiImageRequest: Codable {
    let prompt: String
    let images: [ImageInput]
    let outputConfig: OutputConfig
    
    struct ImageInput: Codable {
        let inlineData: InlineData
    }
    struct InlineData: Codable {
        let mimeType: String
        let data: String
    }
    struct OutputConfig: Codable {
        let width: Int
        let height: Int
    }
}

// MARK: - Response Models
struct GeminiImageResponse: Codable {
    let images: [GeneratedImage]
    
    struct GeneratedImage: Codable {
        let inlineData: InlineData
        struct InlineData: Codable {
            let mimeType: String
            let data: String
        }
    }
}

final class GoogleAPIClient {
    
    private let apiKey: String
    private let session: URLSession
    
    init(apiKey: String, session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
    }
    
    func generateImage(request: GeminiImageRequest, completion: @escaping (Result<GeminiImageResponse, Error>) -> Void) {
        guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-image:generate?key=\(apiKey)") else {
            completion(.failure(NSError(domain: "InvalidURL", code: 0)))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            urlRequest.httpBody = try JSONEncoder().encode(request)
        } catch {
            completion(.failure(error))
            return
        }
        
        session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 0)))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(GeminiImageResponse.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
