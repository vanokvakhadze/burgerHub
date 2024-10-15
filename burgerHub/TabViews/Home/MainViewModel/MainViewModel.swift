////
////  MainViewModel.swift
////  burgerHub
////
////  Created by vano Kvakhadze on 02.10.24.
////
//
//import Foundation
//
//class MainViewModel: ObservableObject {
//    @Published var burgers: [Burgers] = []
//    
//  
//    
//    func fetchMenuData() {
//        let headers = [
//            "x-rapidapi-key": "12cced9067mshc5f9538fa3a5fbbp133134jsn81fc7f6513a4",
//            "x-rapidapi-host": "burgers-hub.p.rapidapi.com"
//        ]
//        
//        let urlString = "https://burgers-hub.p.rapidapi.com/burgers"
//        
//        NetworkService().requestData(urlString: urlString, headers: headers){ [weak self] (result: [Burgers]?, error) in
//            if let result = result {
//                DispatchQueue.main.async {
//                    self?.burgers = result
//                    print("\(self?.burgers)")
//                    
//                }
//            } else if let error = error {
//                print("Failed to fetch exercises: \(error.localizedDescription)")
//            }
//        }
//    }
//    
//    // let cachingService = CachingService()
//    
//    // First, check if data is cached
//    //            cachingService.fetchData(from: url) { cachedData in
//    //                if let data = cachedData {
//    //                    print("Data loaded from cache.")
//    //                    self.parseBurgersData(data: data)
//    //                    return
//    //                }
//    
//    // If not cached, make the API request
//    
//    
//    
//    //        private func parseBurgersData(data: Data) {
//    //            do {
//    //                let decodedData = try JSONDecoder().decode(Burgers.self, from: data)
//    //                DispatchQueue.main.async {
//    //                    self.burgers = decodedData.self // Update the data on the main thread
//    //                    print("Burgers data successfully parsed.")
//    //                }
//    //            } catch {
//    //                print("Failed to decode JSON: \(error.localizedDescription)")
//    //            }
//    //        }
//    
//    
//
//
//
//// it a function which make network calls for array of ids
////func fetchProductDetails(productIDs: [Int]) {
////    
////    let dispatchGroup = DispatchGroup()
////    
////    var fetchedProducts = [Product]()
////    
////    for productID in productIDs {
////        dispatchGroup.enter()
////        
////        let productURL = "https://mcdonald-s-products-api.p.rapidapi.com/us/products/\(Int(productID))"
////        
////        NetworkService().requestData(urlString: productURL, headers: headers) { (product: Product?, error) in
////            if let product = product {
////                fetchedProducts.append(product)
////            } else if let error = error {
////                print("Failed to fetch product \(productID): \(error.localizedDescription)")
////            }
////            
////            dispatchGroup.leave()
////        }
////    }
////    
////    // Once all calls are done
////    dispatchGroup.notify(queue: .main) {
////        print("Fetched products: \(fetchedProducts)")
////    }
//}
//
