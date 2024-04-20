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
        
        // Проверяем, существует ли файл
        if FileManager.default.fileExists(atPath: fileURL.path) {
            // Если файл существует, загружаем данные из него
            self.newsItems = load(fileURL)
        } else {
            // Если файл не существует, создаем новый файл и устанавливаем массив данных в пустой массив
            self.newsItems = []
            if createFile(at: fileURL) {
                // Если файл успешно создан, выводим сообщение об этом
                print("Файл newsItemData.json успешно создан.")
                self.newsItems = load(fileURL)
            } else {
                // Если возникла ошибка при создании файла, выводим сообщение об этом
                print("Ошибка при создании файла newsItemData.json.")
            }
        }
    }
            
    
    private func createFile(at url: URL) -> Bool {
            do {
                let defaultData = Data() // Создаем пустые данные
                try defaultData.write(to: url) // Записываем пустые данные в файл
                print("новый файл создан \(url)")
                self.newsItems = load(url)
                return true
            } catch {
                print("Ошибка при создании файла: \(error)")
                return false
            }
        }
    
    func save() {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(newsItems)
            
            // Получаем путь к директории Documents внутри домашней директории пользователя
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = documentsDirectory.appendingPathComponent("newsItemData.json")
                try jsonData.write(to: fileURL)
                
                // После сохранения данных, загружаем их обратно в newsItems
                self.newsItems = load(fileURL)
                print("Данные успешно сохранены в файл: \(fileURL)")
            } else {
                print("Не удалось получить доступ к директории Documents")
            }
        } catch {
            print("Ошибка при сохранении данных: \(error)")
        }
    }
    
    
    func deleteFile() -> Bool {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = documentsDirectory.appendingPathComponent("newsItemData.json")
        do {
            try FileManager.default.removeItem(at: url)
            print("данные удалены")
            return true
        } catch {
            print("Ошибка при удалении файла: \(error)")
            return false
        }
    }
    
    func clearDataInFile() -> Bool {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = documentsDirectory.appendingPathComponent("newsItemData.json")
        
        // Создаем пустые данные
        let emptyData = Data()
        
        do {
            // Пишем пустые данные в файл, перезаписывая его содержимое
            try emptyData.write(to: url)
            print("Данные в файле успешно стерты")
            self.newsItems = load(url)
            return true
        } catch {
            print("Ошибка при стирании данных в файле: \(error)")
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
            print("Ошибка при загрузке данных: \(error)")
            print("file url: \(fileURL)")
            return []
        }
    }
