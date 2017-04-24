import Foundation
import Alamofire
import SwiftyJSON

class GetGifs {
    private let host = "http://api.giphy.com/"
    private let path = "v1/gifs/"
    private var reqType = "trending?"
    private let apiKey = "api_key=dc6zaTOxFJmzC"
    private var urlReq = ""
    private var numOfResults = 25
    //
    init() {}
    //
    func makeRequest(req: String="trending?") -> String {
        if req == "trending?" {
            self.urlReq = self.host+self.path+req+self.apiKey
        } else {
            let req = req.replacingOccurrences(of: " ", with: "+")
            self.urlReq = self.host+self.path+"search?q="+req+"&"+apiKey
        }
        return urlReq
    }
    //
    func getJson(url: String) throws {
        if Connectivity.isConnectedToInternet() {
            Alamofire.request(url).validate().responseJSON { response in
                if let temp = response.result.value {
                    var jsonResult = JSON(temp)
                    if jsonResult["pagination"]["count"] != 0 {
                        
                    }
                }
            }
        } else {
            throw GettingGifs.notConnectedToInternet
        }
        
    }
    /*
    func getGifs(_ req:String){
        Alamofire.request(req).responseJSON { response in
            if ((response.result.value) != nil){
                let jsonRes = JSON(response.result.value!)
                if jsonRes["pagination"]["count"] != 0{
                    let arr = jsonRes["data"].array!
                    for i in 0..<self.numOfResults{
                        self.temp[i].url = arr[i]["images"]["original"]["url"].string!
                        self.temp[i].width = Double(arr[i]["images"]["original"]["width"].string!)!
                        self.temp[i].height = Double(arr[i]["images"]["original"]["height"].string!)!
                    }
                }
            }
        }
        for i in 0..<self.numOfResults{
            self.gifs.append(self.temp[i])
        }
    }*/
}
