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
    public var results = [GifItem]() {
        didSet {
            while requests.count < results.count {
                requests.append(nil)
            }
        }
    }

    private var requests = [DataRequest?]()
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
                        self.results.append(GifItem(url: url, gifData: nil, width: width, height: height))
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
        if requests.count != 0{
            if let request = requests[index] {
                request.suspend()
            } else {
                return
            }
        }
    }

    public func downloadGifData(index: Int, completionHandler: @escaping (GifItem, Error?) -> Void) {
        if results[index].gifData != nil {
            completionHandler(results[index], nil)
        } else if let request = requests[index] {
            if request.task?.state == .suspended {
                request.resume()
            }
        } else {
            let request = Alamofire.request(results[index].url)
            requests[index] = request
            request.validate().responseData { response in
                // app is fell here
                self.results[index].gifData = response.result.value
                completionHandler(self.results[index], nil)
            }
        }
    }

    private func clear() {
        for request in requests {
            request?.cancel()
        }
        requests.removeAll()
        results.removeAll()
    }
    
    private func validateQuery(queryTerm: String?) -> String {
        var validatedQuery = ""
        let charSet = CharacterSet.punctuationCharacters.union(.newlines).union(.symbols)
        if let query = queryTerm {
            let stringArray = query.components(separatedBy: charSet)
            validatedQuery = stringArray.joined()
            validatedQuery = validatedQuery.trimmingCharacters(in: .whitespaces)
            validatedQuery = validatedQuery.replacingOccurrences(of: " ", with: "+")
            return validatedQuery
        } else {
            return ""
        }
    }
}
