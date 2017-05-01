import Alamofire
import SwiftyJSON

class GetData {
    private let host = "http://api.giphy.com/"
    private let path = "v1/gifs/"
    private let apiKey = "api_key=dc6zaTOxFJmzC"
    private var json = JSON.null
    private var urlReq = ""
    private let numOfResults = 25
    var gifArr = [GifItem]()
    //
    init() {}
    //
    func makeRequest(req: String="trending?") {
        var preparedReq: String
        if req != "trending?" && req != "" {
            preparedReq = "search?q="+req.replacingOccurrences(of: " ", with: "+")+"&"
        } else {
            preparedReq = req
        }
        self.urlReq = self.host+self.path+preparedReq+self.apiKey
    }
    //
    func getJSON(completionHandler: @escaping (JSON, Error?) -> Void) {
        asyncJSON(completionHandler: completionHandler)
    }
    //
    func asyncJSON(completionHandler: @escaping (JSON, Error?) -> Void) {
        Alamofire.request("http://api.giphy.com/v1/gifs/trending?api_key=dc6zaTOxFJmzC").validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                completionHandler(JSON(value), nil)
            case .failure(let error):
                completionHandler(JSON.null, error)
            }
        }
    }
    //
    func getData(json: JSON, completionHandler: @escaping (Bool, Error?) -> Void) {
        asyncData(json:json, completionHandler: completionHandler)
    }
    //
    func asyncData(json: JSON, completionHandler: @escaping (Bool, Error?) -> Void) {
        if json["pagination"]["count"] == 0 {
            print("need to rewrite")
        } else {
            if let arr = json["data"].array {
                for i in 0..<self.numOfResults {
                    if let url = arr[i]["images"]["original"]["url"].string {
                        if let urlObj = URL(string: url) {
                            if let data = try? Data(contentsOf: urlObj) {
                                if let width = arr[i]["images"]["original"]["width"].string {
                                    if let height = arr[i]["images"]["original"]["height"].string {
                                        self.gifArr.append(GifItem(gifData: data, width: Double(width)!, height: Double(height)!))
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
//
}
