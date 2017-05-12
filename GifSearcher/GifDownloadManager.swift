import Alamofire
import SwiftyJSON

fileprivate struct Constants {
    static let trendingKey = "trending?"
    static let host = "http://api.giphy.com/"
    static let path = "v1/gifs/"
    static let apiKey = "api_key=dc6zaTOxFJmzC"
}

class GifDownloadManager {
    private var requestURL: URL? {
        var validatedQuery: String = validateQuery(queryTerm: queryTerm)
        if validatedQuery != "" {
            validatedQuery = "search?q=" + validatedQuery + "&"
        } else {
            validatedQuery = Constants.trendingKey
        }
        return URL(string: Constants.host + Constants.path + validatedQuery + Constants.apiKey)
    }
    public var requestResult = [(gif: GifItem, request: DataRequest?)]()
    private var queryTerm: String?

    public func makeRequest(queryTerm: String, completion: @escaping (Error?) -> ()) {
        clear()
        self.queryTerm = queryTerm
        updateResults(completion: completion)
    }

    private func updateResults(completion: @escaping (Error?) -> ()) {
        guard let url = requestURL else {
            return
        }
        if !Connectivity.isConnectedToInternet() {
            completion(GettingGifsError.notConnectedToInternet)
            return
        }
        Alamofire.request(url).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json["pagination"]["count"] == 0 {
                    completion(GettingGifsError.noResultsFound)
                }
                guard let data = json["data"].array else {
                    return
                }
                for element in data {
                    let original = element["images"]["original"]
                    if let urlString = original["url"].string,
                        let url = URL(string: urlString),
                        let widthString = original["width"].string,
                        let heightString = original["height"].string,
                        let width = Int(widthString), let height = Int(heightString) {
                        self.requestResult.append((gif: GifItem(url: url, gifData: nil, width: width, height: height), request: nil))
                        completion(nil)
                    } else {
                        completion(GettingGifsError.incorrectData)
                    }
                }
            case .failure(let error):
                completion(error)
            }
        }
    }

    public func stopDownloadGifData(index: Int) {
        if requestResult.count != 0 {
            if let request = requestResult[index].request {
                request.suspend()
            }
            else {
                return
            }
        }
    }

    public func downloadGifData(index: Int, completionHandler: @escaping (GifItem, Error?) -> Void) {
        if requestResult[index].gif.gifData != nil {
            completionHandler(requestResult[index].gif, nil)
        } else if let request = requestResult[index].request {
            if request.task?.state == .suspended {
                request.resume()
            }
        } else {
            let request = Alamofire.request(requestResult[index].gif.url)
            requestResult[index].request = request
            request.validate().responseData { response in
                if let data = response.result.value {
                    self.requestResult[index].gif.gifData = data
                    completionHandler(self.requestResult[index].gif, nil)
                } else {
                    return
                }
                
            }
        }
    }

    private func clear() {
        for (_, request) in requestResult {
            request?.cancel()
        }
        requestResult.removeAll()
    }
    
    private func validateQuery(queryTerm: String?) -> String {
        var validatedQuery = ""
        let charSet = CharacterSet.punctuationCharacters.union(.newlines).union(.symbols)
        if let query = queryTerm {
            let stringArray = query.components(separatedBy: charSet)
            validatedQuery = stringArray.joined()
            validatedQuery = validatedQuery.trimmingCharacters(in: .whitespaces)
            validatedQuery = validatedQuery.replacingOccurrences(of: " ", with: "+")
        }
        return validatedQuery
    }
}
