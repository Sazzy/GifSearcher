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
        var preparedQuery: String
        if queryTerm != Constants.trendingKey &&
            queryTerm.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            preparedQuery = "search?q=" + queryTerm.replacingOccurrences(of: " ", with: "+") + "&"
            if !results.isEmpty {
                preparedQuery += "offset=\(results.count)"
            }
        } else {
            preparedQuery = Constants.trendingKey
        }
        return URL(string: Constants.host + Constants.path + preparedQuery + Constants.apiKey)
    }

    public var results = [GifItem]() {
        didSet {
            while requests.count < results.count {
                requests.append(nil)
            }
        }
    }

    private var requests = [DataRequest?]()
    private var queryTerm = Constants.trendingKey

    public func makeRequest(queryTerm: String = Constants.trendingKey, completion: @escaping () -> ()) {
        clear()
        self.queryTerm = queryTerm
        updateResults(completion: completion)
    }

    public func loadMore(completion: @escaping () -> ()) {

    }

    private func updateResults(completion: @escaping () -> ()) {
        guard let url = requestURL else {
            return
        }
        Alamofire.request(url).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                guard let data = json["data"].array else {
//                    completionHandler(nil, NSError(domain: "Incorrect data", code: 1, userInfo: nil))
                    completion()
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
                    } else {
//                        completionHandler(nil, NSError(domain: "Incorrect data", code: 1, userInfo: nil))
                        return
                    }
                }
                completion()
            case .failure(_):
                completion()
                break
                //completionHandler(JSON.null, error)
            }
        }
    }

    public func stopDownloadGifData(index: Int) {
        if let request = requests[index] {
            request.suspend()
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
                self.results[index].gifData = response.result.value
                completionHandler(self.results[index], nil)
            }
        }
    }

    private func clear() {
        requests.removeAll()
        results.removeAll()
    }
}
