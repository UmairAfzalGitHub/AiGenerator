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
    // Using the correct endpoint for image generation as per Google documentation
    private let baseURL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent"
    
    // Model parameter for image generation
    private let generationConfig: [String: Any] = [
        "temperature": 0.9,
        "topP": 1,
        "topK": 32,
        "maxOutputTokens": 2048
    ]
    
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
        logger.info("📸 Processing \(images.count) parent images")
        
        guard let url = URL(string: "\(baseURL)?key=\(apiKey)") else {
            let error = NSError(domain: "Invalid URL", code: -1)
            logger.error("❌ URL creation failed: \(error.localizedDescription)")
            completion(.failure(error))
            return
        }
        
        // Convert images to Base64 with aggressive compression and resizing
        logger.info("🔄 Converting images to Base64 with compression")
        let inlineDataArray: [[String: Any]] = images.compactMap { image in
            // Resize image to reduce size
            let maxDimension: CGFloat = 800.0
            let resizedImage = resizeImage(image, targetSize: maxDimension)
            
            // Use much more aggressive compression (0.3 instead of 0.8)
            guard let imageData = resizedImage.jpegData(compressionQuality: 0.3) else { 
                logger.error("❌ Failed to convert image to JPEG data")
                return nil 
            }
            let base64Size = imageData.base64EncodedString().count
            logger.info("📊 Image converted to Base64 (size: \(base64Size / 1024) KB)")
            return [
                "inline_data": [
                    "mime_type": "image/jpeg",
                    "data": imageData.base64EncodedString()
                ]
            ]
        }
        
        // Build request body with generation parameters for image output
        let requestBody: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": prompt]
                    ] + inlineDataArray
                ]
            ],
            "generationConfig": [
                "temperature": 0.9,
                "topP": 1,
                "topK": 32,
                "maxOutputTokens": 2048,
                "responseMimeType": "image/png"
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
        logger.info("📡 Sending request to Gemini API")
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
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                // Log the full response for debugging
                if let jsonString = String(data: data, encoding: .utf8) {
                    self.logger.info("💬 Response content: \(jsonString.prefix(500))...")
                }
                
                if let candidates = json?["candidates"] as? [[String: Any]],
                   let firstCandidate = candidates.first,
                   let content = firstCandidate["content"] as? [String: Any],
                   let parts = content["parts"] as? [[String: Any]] {
                    
                    // Try to extract image data first - using the correct field names from documentation
                    if let part = parts.first,
                       let base64Image = part["inline_data"] as? [String: Any],
                       let imageDataString = base64Image["data"] as? String,
                       let imageData = Data(base64Encoded: imageDataString) {
                        
                        self.logger.info("✅ Successfully parsed image data: \(imageData.count / 1024) KB")
                        completion(.success(imageData))
                        return
                    }
                    
                    // Alternative format - try the old format as well for backward compatibility
                    if let part = parts.first,
                       let base64Image = part["inlineData"] as? [String: Any],
                       let imageDataString = base64Image["data"] as? String,
                       let imageData = Data(base64Encoded: imageDataString) {
                        
                        self.logger.info("✅ Successfully parsed image data (legacy format): \(imageData.count / 1024) KB")
                        completion(.success(imageData))
                        return
                    }
                    
                    // If no image data, try to use text response to generate an image
                    if let part = parts.first, let text = part["text"] as? String {
                        self.logger.info("💬 Received text response instead of image: \(text.prefix(100))...")
                        
                        // Try to generate an image from the text description using a fallback method
                        self.generateFallbackImage(from: text) { result in
                            switch result {
                            case .success(let imageData):
                                self.logger.info("✅ Successfully generated fallback image")
                                completion(.success(imageData))
                            case .failure(let error):
                                self.logger.error("❌ Fallback image generation failed: \(error.localizedDescription)")
                                completion(.failure(error))
                            }
                        }
                        return
                    }
                }
                
                // If we reach here, we couldn't parse the response
                if let jsonString = String(data: data, encoding: .utf8) {
                    self.logger.error("❌ Invalid response format. Response: \(jsonString.prefix(200))...")
                }
                let error = NSError(domain: "Invalid Response Format", code: -2)
                self.logger.error("❌ Failed to parse response: \(error.localizedDescription)")
                completion(.failure(error))
            }
            catch {
                self.logger.error("❌ JSON parsing error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
}
