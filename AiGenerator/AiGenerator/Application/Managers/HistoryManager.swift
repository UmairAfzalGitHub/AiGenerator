import Foundation
import UIKit
import os.log

/// Model representing a saved baby image with its associated data
struct BabyHistoryItem: Codable, Hashable {
    // MARK: - Properties
    let id: String
    let babyName: String
    let gender: String
    let ethnicity: String
    let age: Int
    let prompt: String
    let createdAt: Date
    let imageFilename: String
    
    // MARK: - Initialization
    init(id: String = UUID().uuidString,
         babyName: String,
         gender: String,
         ethnicity: String,
         age: Int,
         prompt: String,
         createdAt: Date = Date(),
         imageFilename: String) {
        self.id = id
        self.babyName = babyName
        self.gender = gender
        self.ethnicity = ethnicity
        self.age = age
        self.prompt = prompt
        self.createdAt = createdAt
        self.imageFilename = imageFilename
    }
    
    // MARK: - Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // MARK: - Equatable
    static func == (lhs: BabyHistoryItem, rhs: BabyHistoryItem) -> Bool {
        return lhs.id == rhs.id
    }
}

/// Manager for handling baby image history storage and retrieval
final class HistoryManager {
    // MARK: - Singleton
    static let shared = HistoryManager()
    
    // MARK: - Properties
    private let logger = Logger(subsystem: "com.aiGenerator.app", category: "HistoryManager")
    private let historyKey = "baby_history_items"
    private let fileManager = FileManager.default
    
    // MARK: - Initialization
    private init() {
        logger.info("🗂️ HistoryManager initialized")
        createImagesDirectoryIfNeeded()
    }
    
    // MARK: - Directory Management
    private var imagesDirectory: URL? {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("BabyImages")
    }
    
    private func createImagesDirectoryIfNeeded() {
        guard let imagesDirectory = imagesDirectory else {
            logger.error("❌ Could not determine images directory path")
            return
        }
        
        if !fileManager.fileExists(atPath: imagesDirectory.path) {
            do {
                try fileManager.createDirectory(at: imagesDirectory, withIntermediateDirectories: true)
                logger.info("✅ Created images directory at \(imagesDirectory.path)")
            } catch {
                logger.error("❌ Failed to create images directory: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Save Methods
    
    /// Saves a generated baby image to history
    /// - Parameters:
    ///   - image: The generated baby image
    ///   - babyName: Name of the baby
    ///   - gender: Gender of the baby
    ///   - ethnicity: Ethnicity of the baby
    ///   - age: Age of the baby in years
    ///   - prompt: The prompt used to generate the image
    ///   - completion: Completion handler with success or failure
    func saveGeneratedImage(
        image: UIImage,
        babyName: String,
        gender: String,
        ethnicity: String,
        age: Int,
        prompt: String,
        completion: @escaping (Result<BabyHistoryItem, Error>) -> Void
    ) {
        logger.info("💾 Saving generated image for baby: \(babyName)")
        
        // Generate unique filename
        let imageId = UUID().uuidString
        let filename = "\(imageId).jpg"
        
        // Save image to disk
        saveImageToDisk(image, withFilename: filename) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                // Create history item
                let historyItem = BabyHistoryItem(
                    babyName: babyName,
                    gender: gender,
                    ethnicity: ethnicity,
                    age: age,
                    prompt: prompt,
                    imageFilename: filename
                )
                
                // Save to history
                self.saveHistoryItem(historyItem) { saveResult in
                    switch saveResult {
                    case .success:
                        self.logger.info("✅ Successfully saved history item for \(babyName)")
                        completion(.success(historyItem))
                    case .failure(let error):
                        self.logger.error("❌ Failed to save history item: \(error.localizedDescription)")
                        completion(.failure(error))
                    }
                }
                
            case .failure(let error):
                self.logger.error("❌ Failed to save image to disk: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    private func saveImageToDisk(_ image: UIImage, withFilename filename: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let imagesDirectory = imagesDirectory else {
            let error = NSError(domain: "HistoryManager", code: 100, userInfo: [NSLocalizedDescriptionKey: "Images directory not found"])
            completion(.failure(error))
            return
        }
        
        let fileURL = imagesDirectory.appendingPathComponent(filename)
        
        // Compress image to JPEG
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            let error = NSError(domain: "HistoryManager", code: 101, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to JPEG data"])
            completion(.failure(error))
            return
        }
        
        // Write to disk
        do {
            try imageData.write(to: fileURL)
            logger.info("✅ Saved image to \(fileURL.path)")
            completion(.success(()))
        } catch {
            logger.error("❌ Failed to write image data: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    
    private func saveHistoryItem(_ item: BabyHistoryItem, completion: @escaping (Result<Void, Error>) -> Void) {
        // Get existing items
        var historyItems = getAllHistoryItems()
        
        // Add new item
        historyItems.append(item)
        
        // Save updated list
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(historyItems)
            UserDefaults.standard.set(data, forKey: historyKey)
            completion(.success(()))
        } catch {
            logger.error("❌ Failed to encode history items: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    
    // MARK: - Retrieve Methods
    
    /// Gets all baby history items sorted by creation date (newest first)
    /// - Returns: Array of BabyHistoryItem objects
    func getAllHistoryItems() -> [BabyHistoryItem] {
        logger.info("📋 Retrieving all history items")
        
        guard let data = UserDefaults.standard.data(forKey: historyKey) else {
            logger.info("ℹ️ No history items found in UserDefaults")
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            let historyItems = try decoder.decode([BabyHistoryItem].self, from: data)
            logger.info("✅ Retrieved \(historyItems.count) history items")
            
            // Sort by creation date, newest first
            return historyItems.sorted { $0.createdAt > $1.createdAt }
        } catch {
            logger.error("❌ Failed to decode history items: \(error.localizedDescription)")
            return []
        }
    }
    
    /// Loads the image for a specific history item
    /// - Parameter item: The history item to load the image for
    /// - Returns: The UIImage if available, nil otherwise
    func loadImage(for item: BabyHistoryItem) -> UIImage? {
        guard let imagesDirectory = imagesDirectory else {
            logger.error("❌ Images directory not found")
            return nil
        }
        
        let fileURL = imagesDirectory.appendingPathComponent(item.imageFilename)
        
        if fileManager.fileExists(atPath: fileURL.path) {
            if let imageData = try? Data(contentsOf: fileURL),
               let image = UIImage(data: imageData) {
                logger.info("✅ Loaded image for \(item.babyName)")
                return image
            } else {
                logger.error("❌ Failed to load image data for \(item.imageFilename)")
                return nil
            }
        } else {
            logger.error("❌ Image file not found: \(fileURL.path)")
            return nil
        }
    }
    
    // MARK: - Delete Methods
    
    /// Deletes a specific history item and its associated image
    /// - Parameters:
    ///   - item: The history item to delete
    ///   - completion: Completion handler with success or failure
    func deleteHistoryItem(_ item: BabyHistoryItem, completion: @escaping (Result<Void, Error>) -> Void) {
        logger.info("🗑️ Deleting history item for \(item.babyName)")
        
        // Delete image file
        deleteImageFile(filename: item.imageFilename) { [weak self] result in
            guard let self = self else { return }
            
            // Even if image deletion fails, continue with removing the history item
            if case .failure(let error) = result {
                logger.warning("⚠️ Failed to delete image file but continuing: \(error.localizedDescription)")
            }
            
            // Remove item from history
            var historyItems = self.getAllHistoryItems()
            historyItems.removeAll { $0.id == item.id }
            
            // Save updated list
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(historyItems)
                UserDefaults.standard.set(data, forKey: self.historyKey)
                logger.info("✅ Successfully deleted history item for \(item.babyName)")
                completion(.success(()))
            } catch {
                logger.error("❌ Failed to save updated history items: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    private func deleteImageFile(filename: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let imagesDirectory = imagesDirectory else {
            let error = NSError(domain: "HistoryManager", code: 102, userInfo: [NSLocalizedDescriptionKey: "Images directory not found"])
            completion(.failure(error))
            return
        }
        
        let fileURL = imagesDirectory.appendingPathComponent(filename)
        
        if fileManager.fileExists(atPath: fileURL.path) {
            do {
                try fileManager.removeItem(at: fileURL)
                logger.info("✅ Deleted image file: \(filename)")
                completion(.success(()))
            } catch {
                logger.error("❌ Failed to delete image file: \(error.localizedDescription)")
                completion(.failure(error))
            }
        } else {
            logger.warning("⚠️ Image file not found for deletion: \(fileURL.path)")
            // Consider this a success since the file doesn't exist anyway
            completion(.success(()))
        }
    }
    
    /// Clears all history items and associated images
    /// - Parameter completion: Completion handler with success or failure
    func clearAllHistory(completion: @escaping (Result<Void, Error>) -> Void) {
        logger.info("🗑️ Clearing all history")
        
        let historyItems = getAllHistoryItems()
        
        // Clear UserDefaults first
        UserDefaults.standard.removeObject(forKey: historyKey)
        
        // Then delete all image files
        guard let imagesDirectory = imagesDirectory else {
            let error = NSError(domain: "HistoryManager", code: 103, userInfo: [NSLocalizedDescriptionKey: "Images directory not found"])
            completion(.failure(error))
            return
        }
        
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: imagesDirectory, includingPropertiesForKeys: nil)
            for fileURL in fileURLs {
                try fileManager.removeItem(at: fileURL)
            }
            logger.info("✅ Cleared all \(fileURLs.count) image files")
            completion(.success(()))
        } catch {
            logger.error("❌ Failed to clear image files: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
}
