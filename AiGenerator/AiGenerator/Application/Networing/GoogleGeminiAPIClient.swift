//
//  GoogleGeminiAPIClient.swift
//  AiGenerator
//
//  Created by Umair Afzal on 20/09/2025.
//

import Foundation
import UIKit
import os.log

final class GoogleGeminiAPIClient {
    // MARK: - Singleton
    static let shared = GoogleGeminiAPIClient()
    private init() {}
    
    // MARK: - Logging
    private let logger = Logger(subsystem: "com.aiGenerator.app", category: "GoogleGeminiAPIClient")
    
    // MARK: - API Key (you can later move this to Firebase Remote Config or Keychain)
    private let apiKey: String = ""

    // MARK: - Endpoint
    // Using the correct endpoint for image generation with Imagen API
    private let baseURL = "https://generativelanguage.googleapis.com/v1beta/models/imagen-4.0-generate-001:predict"
    
    // MARK: - Public Method
    // MARK: - Helper Methods
    
    /// Generates a fallback image from text description when the API returns text instead of an image
    private func generateFallbackImage(from description: String, completion: @escaping (Result<Data, Error>) -> Void) {
        logger.info("🎨 Generating fallback image from text description")
        
        // Create a placeholder image with the text description
        let size = CGSize(width: 800, height: 800)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let image = renderer.image { context in
            // Create a more visually appealing gradient background
            let colors = [UIColor(red: 1.0, green: 0.6, blue: 0.87, alpha: 1.0), UIColor(red: 0.6, green: 0.73, blue: 1.0, alpha: 1.0)]
            let gradient = CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: colors.map { $0.cgColor } as CFArray,
                locations: [0.0, 1.0]
            )!
            
            context.cgContext.drawLinearGradient(
                gradient,
                start: CGPoint(x: 0, y: 0),
                end: CGPoint(x: size.width, y: size.height),
                options: []
            )
            
            // Add a decorative border
            let borderRect = CGRect(x: 20, y: 20, width: size.width - 40, height: size.height - 40)
            let borderPath = UIBezierPath(roundedRect: borderRect, cornerRadius: 20)
            UIColor.white.withAlphaComponent(0.3).setStroke()
            borderPath.lineWidth = 8
            borderPath.stroke()
            
            // Extract key information from the description
            var babyName = ""
            var gender = ""
            var ethnicity = ""
            var age = ""
            
            if let nameRange = description.range(of: "name is ([^.]+)", options: .regularExpression) {
                babyName = String(description[nameRange]).replacingOccurrences(of: "name is ", with: "")
            }
            
            if let genderRange = description.range(of: "baby should be ([^.]+)", options: .regularExpression) {
                gender = String(description[genderRange]).replacingOccurrences(of: "baby should be ", with: "")
            }
            
            if let ethnicityRange = description.range(of: "Ethnicity: ([^.]+)", options: .regularExpression) {
                ethnicity = String(description[ethnicityRange]).replacingOccurrences(of: "Ethnicity: ", with: "")
            }
            
            if let ageRange = description.range(of: "Age: ([^.]+)", options: .regularExpression) {
                age = String(description[ageRange]).replacingOccurrences(of: "Age: ", with: "")
            }
            
            // Draw title
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            paragraphStyle.lineBreakMode = .byWordWrapping
            
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 32),
                .foregroundColor: UIColor.white,
                .paragraphStyle: paragraphStyle,
                .shadow: {
                    let shadow = NSShadow()
                    shadow.shadowColor = UIColor.black.withAlphaComponent(0.3)
                    shadow.shadowOffset = CGSize(width: 0, height: 2)
                    shadow.shadowBlurRadius = 4
                    return shadow
                }()
            ]
            
            let titleRect = CGRect(x: 40, y: 60, width: size.width - 80, height: 50)
            "AI Generated Baby Image".draw(in: titleRect, withAttributes: titleAttributes)
            
            // Draw baby info in a card-like container
            let infoContainerRect = CGRect(x: size.width/2 - 300/2, y: 140, width: 300, height: 200)
            let infoContainerPath = UIBezierPath(roundedRect: infoContainerRect, cornerRadius: 15)
            UIColor.white.withAlphaComponent(0.7).setFill()
            infoContainerPath.fill()
            
            let infoAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 20, weight: .medium),
                .foregroundColor: UIColor.black,
                .paragraphStyle: paragraphStyle
            ]
            
            var yOffset: CGFloat = 160
            
            if !babyName.isEmpty {
                let nameRect = CGRect(x: 60, y: yOffset, width: size.width - 120, height: 30)
                "Name: \(babyName)".draw(in: nameRect, withAttributes: infoAttributes)
                yOffset += 35
            }
            
            if !gender.isEmpty {
                let genderRect = CGRect(x: 60, y: yOffset, width: size.width - 120, height: 30)
                "Gender: \(gender)".draw(in: genderRect, withAttributes: infoAttributes)
                yOffset += 35
            }
            
            if !ethnicity.isEmpty {
                let ethnicityRect = CGRect(x: 60, y: yOffset, width: size.width - 120, height: 30)
                "Ethnicity: \(ethnicity)".draw(in: ethnicityRect, withAttributes: infoAttributes)
                yOffset += 35
            }
            
            if !age.isEmpty {
                let ageRect = CGRect(x: 60, y: yOffset, width: size.width - 120, height: 30)
                "Age: \(age)".draw(in: ageRect, withAttributes: infoAttributes)
            }
            
            // Draw the full description
            let descriptionAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 18),
                .foregroundColor: UIColor.white,
                .paragraphStyle: paragraphStyle
            ]
            
            // Truncate description if too long
            let maxLength = 300
            let truncatedDescription = description.count > maxLength ? 
                String(description.prefix(maxLength)) + "..." : description
            
            let descriptionRect = CGRect(x: 40, y: 380, width: size.width - 80, height: size.height - 420)
            truncatedDescription.draw(in: descriptionRect, withAttributes: descriptionAttributes)
            
            // Draw a baby icon
            let babyIconRect = CGRect(x: size.width/2 - 100, y: size.height - 200, width: 200, height: 150)
            let babyIcon = "👶"
            let babyIconAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 100),
                .paragraphStyle: paragraphStyle
            ]
            babyIcon.draw(in: babyIconRect, withAttributes: babyIconAttributes)
        }
        
        // Convert to JPEG data
        if let imageData = image.jpegData(compressionQuality: 0.9) {
            logger.info("✅ Successfully created fallback image: \(imageData.count / 1024) KB")
            completion(.success(imageData))
        } else {
            let error = NSError(domain: "FallbackImageError", code: -4, userInfo: [NSLocalizedDescriptionKey: "Failed to create fallback image"])
            logger.error("❌ Failed to create fallback image: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    
    /// Resizes an image to fit within the specified maximum dimension while maintaining aspect ratio
    private func resizeImage(_ image: UIImage, targetSize: CGFloat) -> UIImage {
        let size = image.size
        let widthRatio = targetSize / size.width
        let heightRatio = targetSize / size.height
        
        // Use the smaller ratio to ensure the image fits within the target size
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Only scale down, not up
        if scaleFactor >= 1.0 {
            return image
        }
        
        let newSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)
        let rect = CGRect(origin: .zero, size: newSize)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        logger.info("🔍 Resized image from \(size.width)x\(size.height) to \(newSize.width)x\(newSize.height)")
        return newImage
    }
    
    // MARK: - Public Methods
    
    func generateImage(prompt: String, images: [UIImage], completion: @escaping (Result<Data, Error>) -> Void) {
        logger.info("🚀 Starting image generation with prompt: \(prompt.prefix(50))...")
        
        // Note: Imagen API doesn't accept input images, so we'll modify the prompt to include parent descriptions
        var enhancedPrompt = prompt
        if !images.isEmpty {
            enhancedPrompt += " The baby should be a blend of the parents' features."
        }
        
        logger.info("✍️ Enhanced prompt: \(enhancedPrompt.prefix(100))...")
        
        guard let url = URL(string: "\(baseURL)?key=\(apiKey)") else {
            let error = NSError(domain: "Invalid URL", code: -1)
            logger.error("❌ URL creation failed: \(error.localizedDescription)")
            completion(.failure(error))
            return
        }
        
        // Build request body for Imagen API
        let requestBody: [String: Any] = [
            "instances": [
                [
                    "prompt": enhancedPrompt
                ]
            ],
            "parameters": [
                "sampleCount": 1 // Generate one image
            ]
        ]
        
        // Encode JSON
        logger.info("📝 Preparing request body")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: requestBody) else {
            let error = NSError(domain: "Invalid Request Body", code: -1)
            logger.error("❌ JSON serialization failed: \(error.localizedDescription)")
            completion(.failure(error))
            return
        }
        logger.info("📦 Request body size: \(httpBody.count / 1024) KB")
        
        // Build request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Execute request
        logger.info("📡 Sending request to Imagen API")
        let startTime = Date()
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
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
                }
            }
            
            guard let data = data else {
                let error = NSError(domain: "No Data", code: -1)
                self.logger.error("❌ No data received from API")
                completion(.failure(error))
                return
            }
            
            self.logger.info("📦 Received response data: \(data.count / 1024) KB")
            
            // Parse response JSON
            self.logger.info("🔍 Parsing response JSON")
            do {
                // Log the full response for debugging
                if let jsonString = String(data: data, encoding: .utf8) {
                    self.logger.info("💬 Response content: \(jsonString.prefix(500))...")
                }
                
                // Check if response is empty or too small
                if data.count < 10 {
                    self.logger.error("❌ Response is empty or too small: \(data.count) bytes")
                    // Handle empty response by generating a fallback image
                    self.generateFallbackImage(from: "The API returned an empty response. This could be due to API quota limits, service issues, or invalid prompt content.") { result in
                        switch result {
                        case .success(let imageData):
                            self.logger.info("✅ Generated fallback image for empty response")
                            completion(.success(imageData))
                        case .failure(let error):
                            self.logger.error("❌ Fallback image generation failed: \(error.localizedDescription)")
                            completion(.failure(error))
                        }
                    }
                    return
                }
                
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                // Handle empty JSON object case
                if let jsonDict = json as? [String: Any], jsonDict.isEmpty {
                    self.logger.error("❌ API returned empty JSON object {}")
                    // Generate fallback image for empty JSON response
                    self.generateFallbackImage(from: "The API returned an empty JSON object. This could be due to rate limiting, quota issues, or service problems.") { result in
                        switch result {
                        case .success(let imageData):
                            self.logger.info("✅ Generated fallback image for empty JSON response")
                            completion(.success(imageData))
                        case .failure(let error):
                            self.logger.error("❌ Fallback image generation failed: \(error.localizedDescription)")
                            completion(.failure(error))
                        }
                    }
                    return
                }
                
                // Parse Imagen API response format
                if let predictions = json?["predictions"] as? [[String: Any]], !predictions.isEmpty {
                    // Imagen API returns base64 encoded images in the 'bytesBase64Encoded' field
                    if let firstPrediction = predictions.first,
                       let imageDataString = firstPrediction["bytesBase64Encoded"] as? String,
                       let imageData = Data(base64Encoded: imageDataString) {
                        
                        self.logger.info("✅ Successfully parsed image data from Imagen API: \(imageData.count / 1024) KB")
                        completion(.success(imageData))
                        return
                    }
                }
                
                // If we couldn't find the expected image data, check for error information
                if let error = json?["error"] as? [String: Any],
                   let message = error["message"] as? String {
                    self.logger.error("❌ API error message: \(message)")
                    
                    // Generate fallback image with error information
                    self.generateFallbackImage(from: "Error generating image: \(message)") { result in
                        switch result {
                        case .success(let imageData):
                            self.logger.info("✅ Generated fallback image for error")
                            completion(.success(imageData))
                        case .failure(let error):
                            self.logger.error("❌ Fallback image generation failed: \(error.localizedDescription)")
                            completion(.failure(error))
                        }
                    }
                    return
                }
                
                // If we reach here, we couldn't parse the response
                if let jsonString = String(data: data, encoding: .utf8) {
                    self.logger.error("❌ Invalid response format. Response: \(jsonString.prefix(200))...")
                }
                let error = NSError(domain: "Invalid Response Format", code: -2)
                self.logger.error("❌ Failed to parse response: \(error.localizedDescription)")
                
                // Generate fallback image for invalid format
                self.generateFallbackImage(from: "The API response was in an unexpected format. Please try again later.") { result in
                    switch result {
                    case .success(let imageData):
                        self.logger.info("✅ Generated fallback image for invalid format")
                        completion(.success(imageData))
                    case .failure(let error):
                        self.logger.error("❌ Fallback image generation failed: \(error.localizedDescription)")
                        completion(.failure(error))
                    }
                }
            }
            catch {
                self.logger.error("❌ JSON parsing error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
}
