//
//  modelData.swift
//  Dota2 Update Notifier
//
//  Created by user on 13.04.2024.
//

import Foundation

@Observable 
class ModelData: ObservableObject {
    var newsItems: [NewsItem]

    
    init() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent("newsItemData.json")
        
        // Checking if the file exists.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            // If the file exists, we load data from it.
            self.newsItems = load(fileURL)
        } else {
            // If the file does not exist, we create a new file with an empty array.
            self.newsItems = []
            if createFile(at: fileURL) {
                print("The newsItemData.json file has been successfully created.")
                self.newsItems = load(fileURL)
            } else {
                print("Error creating the newsItemData.json file.")
            }
        }
    }
            
    
    private func createFile(at url: URL) -> Bool {
            do {
                let defaultData = Data() // Creating empty data.
                try defaultData.write(to: url) // Writing empty data to the file.
                print("A new file has been created \(url)")
                self.newsItems = load(url)
                return true
            } catch {
                print("Error creating the file: \(error)")
                return false
            }
        }
    
    func save() {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(newsItems)
            
            // Getting the path to the Documents directory inside the user's home directory
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = documentsDirectory.appendingPathComponent("newsItemData.json")
                try jsonData.write(to: fileURL)
                
                // After saving the data, we load it back into newsItems
                self.newsItems = load(fileURL)
                print("The data has been successfully saved to the file \(fileURL)")
            } else {
                print("Failed to access the Documents directory.")
            }
        } catch {
            print("Error saving data: \(error)")
        }
    }
    
    
    func deleteFile() -> Bool {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = documentsDirectory.appendingPathComponent("newsItemData.json")
        do {
            try FileManager.default.removeItem(at: url)
            print("The data has been deleted.")
            return true
        } catch {
            print("Error deleting the file: \(error)")
            return false
        }
    }
    
    func clearDataInFile() -> Bool {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = documentsDirectory.appendingPathComponent("newsItemData.json")
        
        // Creating empty data.
        let emptyData = Data()
        
        do {
            // Writing empty data to the file, overwriting its contents
            try emptyData.write(to: url)
            print("The data in the file has been successfully cleared.")
            self.newsItems = load(url)
            return true
        } catch {
            print("Error clearing data in the file: \(error)")
            return false
        }
    }

}

private func load(_ fileURL: URL) -> [NewsItem] {
    do {
        let jsonData = try Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        let newsItems = try decoder.decode([NewsItem].self, from: jsonData)
        return newsItems
    } catch {
        print("Error loading data: \(error)")
        print("file url: \(fileURL)")
        return []
    }
}


@Observable
class CountNewsItems: ObservableObject {
    var count: Int
    
    init() {
        self.count = ModelData().newsItems.count
        NotificationCenter.default.addObserver(forName: .newsItemsDidChange, object: nil, queue: nil) { [weak self] _ in
            self?.handleNewsItemsChange()
        }
    }
        
    private func handleNewsItemsChange() {
        // Updating the count value and executing the function
        self.count = ModelData().newsItems.count
        // Call your function here
        Notifier().postNotification()
    }
}

// Extension for notifying changes in ModelData().newsItems
extension Notification.Name {
    static let newsItemsDidChange = Notification.Name("newsItemsDidChange")
}
