//
//  SearchAPI.swift
//  Sankets-TestApp
//
//  Created by Sanket on 29/11/18.
//  Copyright © 2018 Developer Sanket. All rights reserved.
//

import Foundation

class SearchAPI {
    typealias updateSearchResult = (ResponseResult?,String) -> ()


    var resData : ResponseResult?
    var errorMessage = ""
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?



    func getSearchResult(searchKeyword:String,completion: @escaping updateSearchResult ) {
        dataTask?.cancel()

        var cacheResponse = ResponseCacheHelper.get().readCache(searchKey: searchKeyword as NSString)
        if cacheResponse != nil{
            self.updateSearchResults(cacheResponse!)
            DispatchQueue.main.async {
                completion(self.resData, self.errorMessage)
            }
            return
        }
        //
        if(searchKeyword == "") {
            print("cannot proceed with empty search keyword : getSearchResult method")
            DispatchQueue.main.async {
                self.errorMessage = "search keyword cannot be null"
                completion(self.resData, self.errorMessage)
            }
            return
        }

        var httpBodyRequest = ["emailId":"<\(searchKeyword)>"]


        let url = "http://surya-interview.appspot.com/list"
        guard let Url = URL(string: url) else {print("URL Error"); return}
        var request = URLRequest(url:Url)

        request.httpMethod = "POST"


        guard let httpBody = try? JSONSerialization.data(withJSONObject: httpBodyRequest, options: JSONSerialization.WritingOptions.prettyPrinted) else { print("Error in httpBody of getSearchResult method")
            return

        }


        request.httpBody = httpBody

        dataTask = defaultSession.dataTask(with: request) { data, response, error in
            defer { self.dataTask = nil }
            if let error = error {
                self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
            } else if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                print(response)
                ResponseCacheHelper.get().writeInCache(searchKey: searchKeyword, result: data)
                self.updateSearchResults(data)
                DispatchQueue.main.async {
                    completion(self.resData, self.errorMessage)
                }
            } else {
                print(error as Any)
            }
        }
        dataTask?.resume()

    }

    fileprivate func updateSearchResults(_ data: Data) {
        print(data, "in updateSearchResults method")
        do {
            let fetchedSyllabustRes = try JSONDecoder().decode(ResponseResult.self, from: data)
            resData = (fetchedSyllabustRes)

            print(resData as Any ,"is the fetched Result")
        }
        catch let parseError as NSError {
            errorMessage += "Response parsing error: \(parseError.localizedDescription)\n"
            print(errorMessage, " This is the error in data")
        }
    }

}
