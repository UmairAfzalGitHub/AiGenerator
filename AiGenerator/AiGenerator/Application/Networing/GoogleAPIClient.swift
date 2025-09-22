//
//  GoogleAPIClient.swift
//  AiGenerator
//
//  Created by Umair Afzal on 20/09/2025.
//

import Foundation
import os.log

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
    private let logger = Logger(subsystem: "com.aiGenerator.app", category: "GoogleAPIClient")
    
    init(apiKey: String, session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
        logger.info("🔗 GoogleAPIClient initialized with API key: \(apiKey.prefix(5))...")
    }
    
    func generateImage(request: GeminiImageRequest, completion: @escaping (Result<GeminiImageResponse, Error>) -> Void) {
        logger.info("🚀 Starting image generation with prompt: \(request.prompt.prefix(50))...")
        logger.info("📸 Processing \(request.images.count) input images")
        logger.info("📊 Output dimensions: \(request.outputConfig.width)x\(request.outputConfig.height)")
        
        guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-image:generate?key=\(apiKey)") else {
            let error = NSError(domain: "InvalidURL", code: 0)
            logger.error("❌ URL creation failed: \(error.localizedDescription)")
            completion(.failure(error))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        logger.info("📝 Encoding request body")
        do {
            let encodedData = try JSONEncoder().encode(request)
            urlRequest.httpBody = encodedData
            logger.info("📦 Request body size: \(encodedData.count / 1024) KB")
        } catch {
            logger.error("❌ Request encoding failed: \(error.localizedDescription)")
            completion(.failure(error))
            return
        }
        
        logger.info("📡 Sending request to Gemini API")
        let startTime = Date()
        session.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let self = self else { return }
            
            let requestDuration = Date().timeIntervalSince(startTime)
            self.logger.info("⏱️ Request completed in \(String(format: "%.2f", requestDuration)) seconds")
            
            if let error = error {
                self.logger.error("❌ Network error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                self.logger.info("📊 Response status code: \(httpResponse.statusCode)")
                if httpResponse.statusCode != 200 {
                    self.logger.error("❌ API returned non-200 status code: \(httpResponse.statusCode)")
                    if let data = data, let errorBody = String(data: data, encoding: .utf8) {
                        self.logger.error("❌ Error response: \(errorBody.prefix(200))...")
                    }
                }
            }
            
            guard let data = data else {
                let error = NSError(domain: "NoData", code: 0)
                self.logger.error("❌ No data received from API")
                completion(.failure(error))
                return
            }
            
            self.logger.info("📦 Received response data: \(data.count / 1024) KB")
            
            do {
                self.logger.info("🔍 Decoding response data")
                let result = try JSONDecoder().decode(GeminiImageResponse.self, from: data)
                self.logger.info("✅ Successfully decoded response with \(result.images.count) images")
                completion(.success(result))
            } catch {
                self.logger.error("❌ JSON decoding error: \(error.localizedDescription)")
                if let responseString = String(data: data, encoding: .utf8) {
                    self.logger.error("💬 Response content: \(responseString.prefix(200))...")
                }
                completion(.failure(error))
            }
        }.resume()
    }
}
