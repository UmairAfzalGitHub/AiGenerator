//
//  BabyImageManager.swift
//  AiGenerator
//
//  Created by Umair Afzal on 20/09/2025.
//

import Foundation
import UIKit
import os.log

struct PromptOptions {
    static let styles = [
        "highly realistic portrait",
        "digital painting",
        "soft studio lighting",
        "cinematic photography",
        "modern illustration",
        "cute cartoon style"
    ]
    
    static let backgrounds = [
        "plain white background",
        "park with greenery",
        "soft blurred background",
        "indoor baby room",
        "studio photo shoot",
        "beach at sunset"
    ]
    
    static let moods = [
        "smiling",
        "playful",
        "peaceful",
        "curious",
        "happy and joyful"
    ]
    
    static let ageDescriptors: [String: String] = [
        "0": "newborn",
        "1": "1-year-old toddler",
        "2": "2-year-old toddler",
        "5": "5-year-old child",
        "10": "10-year-old child",
        "15": "15-year-old teenager"
    ]
}

final class BabyImageManager {
    static let shared = BabyImageManager()
    
    // MARK: - Logging
    private let logger = Logger(subsystem: "com.aiGenerator.app", category: "BabyImageManager")
    
    private init() {
        logger.info("👶 BabyImageManager initialized")
    }
    
    func generateBabyImage(
        mother: UIImage,
        father: UIImage,
        gender: String? = nil,
        ethnicity: String? = nil,
        babyName: String? = nil,
        age: Int? = nil,
        completion: @escaping (Result<UIImage, Error>) -> Void
    ) {
        logger.info("🚀 Starting baby image generation")
        logger.info("👨‍👩‍👧 Parameters - Gender: \(gender ?? "not specified"), Ethnicity: \(ethnicity ?? "not specified"), Name: \(babyName ?? "not specified"), Age: \(age?.description ?? "not specified")")
        
        // Validate input images
        guard mother.size.width > 0 && mother.size.height > 0 else {
            let error = NSError(domain: "BabyImageManager", code: 100, userInfo: [NSLocalizedDescriptionKey: "Invalid mother image"])
            logger.error("❌ Mother image validation failed: \(error.localizedDescription)")
            completion(.failure(error))
            return
        }
        
        guard father.size.width > 0 && father.size.height > 0 else {
            let error = NSError(domain: "BabyImageManager", code: 101, userInfo: [NSLocalizedDescriptionKey: "Invalid father image"])
            logger.error("❌ Father image validation failed: \(error.localizedDescription)")
            completion(.failure(error))
            return
        }
        
        logger.info("📷 Mother image size: \(mother.size.width)x\(mother.size.height)")
        logger.info("📷 Father image size: \(father.size.width)x\(father.size.height)")
        
        let prompt = buildDynamicPrompt(
            gender: gender,
            ethnicity: ethnicity,
            babyName: babyName,
            age: age
        )
        
        logger.info("💬 Generated prompt: \(prompt)")
        
        logger.info("📡 Calling GoogleGeminiAPIClient to generate image")
        let startTime = Date()
        
        GoogleGeminiAPIClient.shared.generateImage(
            prompt: prompt,
            images: [mother, father]
        ) { [weak self] result in
            guard let self = self else { return }
            
            let processingTime = Date().timeIntervalSince(startTime)
            self.logger.info("⏱️ Total processing time: \(String(format: "%.2f", processingTime)) seconds")
            
            switch result {
            case .success(let data):
                self.logger.info("📦 Received image data: \(data.count / 1024) KB")
                
                if let image = UIImage(data: data) {
                    self.logger.info("✅ Successfully created baby image: \(image.size.width)x\(image.size.height)")
                    completion(.success(image))
                } else {
                    let error = NSError(domain: "ImageDecodeError", code: -3, userInfo: [NSLocalizedDescriptionKey: "Failed to decode image data"])
                    self.logger.error("❌ Image decoding failed: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            case .failure(let error):
                self.logger.error("❌ Generation failed: \(error.localizedDescription)")
                
                // Create a more user-friendly error based on the underlying error
                let userFriendlyError: Error
                
                if let nsError = error as NSError? {
                    if nsError.domain == "NSPOSIXErrorDomain" && nsError.code == 40 {
                        // Handle "Message too long" error
                        let friendlyError = NSError(
                            domain: "BabyImageManager",
                            code: 200,
                            userInfo: [NSLocalizedDescriptionKey: "The parent images are too large. Please use smaller images or try again."]
                        )
                        self.logger.info("🚨 Converted 'Message too long' error to user-friendly message")
                        userFriendlyError = friendlyError
                    } else if nsError.domain.contains("URL") || nsError.localizedDescription.contains("network") {
                        // Handle network connectivity issues
                        let friendlyError = NSError(
                            domain: "BabyImageManager",
                            code: 201,
                            userInfo: [NSLocalizedDescriptionKey: "Network connection issue. Please check your internet connection and try again."]
                        )
                        self.logger.info("🚨 Converted network error to user-friendly message")
                        userFriendlyError = friendlyError
                    } else {
                        // Generic API error
                        let friendlyError = NSError(
                            domain: "BabyImageManager",
                            code: 202,
                            userInfo: [NSLocalizedDescriptionKey: "Unable to generate baby image. Please try again later.", 
                                       NSUnderlyingErrorKey: error]
                        )
                        userFriendlyError = friendlyError
                    }
                } else {
                    userFriendlyError = error
                }
                
                completion(.failure(userFriendlyError))
            }
        }
    }
    
    // MARK: - Prompt Generator
    private func buildDynamicPrompt(
        gender: String?,
        ethnicity: String?,
        babyName: String?,
        age: Int?
    ) -> String {
        logger.info("📝 Building dynamic prompt")
        
        let style = PromptOptions.styles.randomElement() ?? ""
        let background = PromptOptions.backgrounds.randomElement() ?? ""
        let mood = PromptOptions.moods.randomElement() ?? ""
        
        logger.info("🎨 Selected style: \(style)")
        logger.info("🌄 Selected background: \(background)")
        logger.info("😊 Selected mood: \(mood)")
        
        // Start with a clear instruction to generate an image, not text
        var prompt = "CREATE AN IMAGE: Generate a \(style) of a baby based on the parents provided. DO NOT DESCRIBE THE IMAGE, GENERATE THE ACTUAL IMAGE."
        
        if let gender = gender {
            prompt += " The baby should be \(gender)."
            logger.info("👪 Added gender to prompt: \(gender)")
        }
        if let ethnicity = ethnicity {
            prompt += " Ethnicity: \(ethnicity)."
            logger.info("🌍 Added ethnicity to prompt: \(ethnicity)")
        }
        if let babyName = babyName {
            prompt += " The baby's name is \(babyName)."
            logger.info("📛 Added name to prompt: \(babyName)")
        }
        if let age = age {
            let descriptor = PromptOptions.ageDescriptors[String(age)] ?? "\(age)-year-old child"
            prompt += " Age: \(descriptor)."
            logger.info("👶 Added age to prompt: \(descriptor)")
        }
        
        prompt += " The baby is \(mood), with a \(background)."
        logger.info("💬 Final prompt length: \(prompt.count) characters")
        return prompt
    }
}
