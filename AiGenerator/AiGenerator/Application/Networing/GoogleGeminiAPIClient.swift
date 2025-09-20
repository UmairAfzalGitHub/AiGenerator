//
//  GoogleGeminiAPIClient.swift
//  AiGenerator
//
//  Created by Umair Afzal on 20/09/2025.
//

import Foundation
import UIKit

final class GoogleGeminiAPIClient {
    // MARK: - Singleton
    static let shared = GoogleGeminiAPIClient()
    private init() {}
    
    // MARK: - API Key (you can later move this to Firebase Remote Config or Keychain)
    private let apiKey: String = "6OJctxG6RVnnZb6tpeAEnK8"
    
    // MARK: - Endpoint
    private let baseURL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent"
    
    // MARK: - Public Method
    func generateImage(prompt: String, images: [UIImage], completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)?key=\(apiKey)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }
        
        // Convert images to Base64
        let inlineDataArray: [[String: Any]] = images.compactMap { image in
            guard let imageData = image.jpegData(compressionQuality: 0.8) else { return nil }
            return [
                "mimeType": "image/jpeg",
                "data": imageData.base64EncodedString()
            ]
        }
        
        // Build request body
        let requestBody: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": prompt]
                    ] + inlineDataArray.map { ["inlineData": $0] }
                ]
            ]
        ]
        
        // Encode JSON
        guard let httpBody = try? JSONSerialization.data(withJSONObject: requestBody) else {
            completion(.failure(NSError(domain: "Invalid Request Body", code: -1)))
            return
        }
        
        // Build request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Execute request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: -1)))
                return
            }
            
            // Parse response JSON
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                if let candidates = json?["candidates"] as? [[String: Any]],
                   let firstCandidate = candidates.first,
                   let content = firstCandidate["content"] as? [String: Any],
                   let parts = content["parts"] as? [[String: Any]],
                   let base64Image = parts.first?["inlineData"] as? [String: Any],
                   let imageDataString = base64Image["data"] as? String,
                   let imageData = Data(base64Encoded: imageDataString) {
                    
                    completion(.success(imageData))
                } else {
                    completion(.failure(NSError(domain: "Invalid Response Format", code: -2)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
