//
//  BabyImageManager.swift
//  AiGenerator
//
//  Created by Umair Afzal on 20/09/2025.
//

import Foundation
import UIKit

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
    private init() {}
    
    func generateBabyImage(
        mother: UIImage,
        father: UIImage,
        gender: String? = nil,
        ethnicity: String? = nil,
        babyName: String? = nil,
        age: Int? = nil,
        completion: @escaping (Result<UIImage, Error>) -> Void
    ) {
        let prompt = buildDynamicPrompt(
            gender: gender,
            ethnicity: ethnicity,
            babyName: babyName,
            age: age
        )
        
        GoogleGeminiAPIClient.shared.generateImage(
            prompt: prompt,
            images: [mother, father]
        ) { result in
            switch result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    completion(.success(image))
                } else {
                    completion(.failure(NSError(domain: "ImageDecodeError", code: -3)))
                }
            case .failure(let error):
                completion(.failure(error))
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
        let style = PromptOptions.styles.randomElement() ?? ""
        let background = PromptOptions.backgrounds.randomElement() ?? ""
        let mood = PromptOptions.moods.randomElement() ?? ""
        
        var prompt = "Generate a \(style) of a baby based on the parents provided."
        
        if let gender = gender {
            prompt += " The baby should be \(gender)."
        }
        if let ethnicity = ethnicity {
            prompt += " Ethnicity: \(ethnicity)."
        }
        if let babyName = babyName {
            prompt += " The baby's name is \(babyName)."
        }
        if let age = age {
            let descriptor = PromptOptions.ageDescriptors[String(age)] ?? "\(age)-year-old child"
            prompt += " Age: \(descriptor)."
        }
        
        prompt += " The baby is \(mood), with a \(background)."
        return prompt
    }
}
