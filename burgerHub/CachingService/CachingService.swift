//
//  CachingService.swift
//  burgerHub
//
//  Created by vano Kvakhadze on 02.10.24.
//

import Foundation


public enum NetworkError: Error {
    case invalidResponse
    case httpError(code: Int)
    case noData
    case decodeError
    
}

class CachingService: ObservableObject, Hashable, Equatable {
    @Published var burgers: [Burgers] = []
    
    static func == (lhs: CachingService, rhs: CachingService) -> Bool {
            // Add custom comparison logic for CachingService if needed
            return true // Or some meaningful comparison based on the properties of CachingService
        }
        
        func hash(into hasher: inout Hasher) {
            // Add custom hashing logic for CachingService if needed
            // For example:
            hasher.combine("some unique property")
        }
    
    var memoryCache = [String: Data]()
    var diskCachePath = "/burger/documents"
    
    init() {
        setupCache()
        // Try fetching cached data from disk when the app starts
    }
    
    func fetchData() {
        let headers = [
            "x-rapidapi-key": "ee8e6ad656msh1622ed26a2ea971p11ddb1jsn86cfe5139e63",
            "x-rapidapi-host": "burgers-hub.p.rapidapi.com"
        ]
        
        let urlString = "https://burgers-hub.p.rapidapi.com/burgers"
        
        if let url = URL(string: urlString) {
            fetchData(from: url, headers: headers) { result in
                print("\(result)")
                self.burgers = result ?? []
            }
        }
    }
    
    
    
    private func setupCache() {
        if let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            let diskCacheURL = cachesDirectory.appendingPathComponent(diskCachePath)
            do {
                try FileManager.default.createDirectory(at: diskCacheURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error setting up cache directory: \(error)")
            }
        }
    }
    
    // Fetches data from cache and decodes it
    func fetchFromDiskCache() {
        if let diskCacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent(diskCachePath),
           let cachedData = try? Data(contentsOf: diskCacheURL.appendingPathComponent(diskCachePath)) {
            print("Fetched data from disk cache")
        } else {
            print("No cached data found on disk")
        }
    }
    
    // Fetches data from network and caches it
    func fetchData(from url: URL, headers: [String: String], completion: @escaping ([Burgers]?) -> Void) {
        // Check memory cache
        if let cachedData = memoryCache[url.absoluteString] {
                let decodedBurgers = decodeData(cachedData)
                completion(decodedBurgers)
                return
            }

            // Check disk cache
            if let diskCacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent(diskCachePath),
               let cachedData = try? Data(contentsOf: diskCacheURL.appendingPathComponent(url.lastPathComponent)) {
                memoryCache[url.absoluteString] = cachedData
                let decodedBurgers = decodeData(cachedData)
                completion(decodedBurgers)
                return
            }

        // Create the URLRequest with headers
        var request = URLRequest(url: url)
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        // Fetch data from network
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error during network request: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            guard let data = data else {
                print("No data received from network.")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            
            
            // მემორიში ვინახავთ
            self.memoryCache[url.absoluteString] = data
            
            // დისკზე ვინახავთ
            if let diskCacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent(self.diskCachePath) {
                do {
                    try data.write(to: diskCacheURL.appendingPathComponent(url.lastPathComponent))
                } catch {
                    
                }
            }
            let decodedBurgers = self.decodeData(data)
            print("\(String(describing: decodedBurgers))")
            DispatchQueue.main.async {
                completion(decodedBurgers)
            }
            
        }.resume()
    }
    
    private func decodeData(_ data: Data) -> [Burgers]? {
        do {
            let burgers = try JSONDecoder().decode([Burgers].self, from: data)
            return burgers
        } catch {
            print("Failed to decode burgers: \(error)")
            return nil
        }
    }
}
