import Foundation


class GithubApi {
    static private let API_ENDPOINT = "https://api.github.com"
    static private let COLLABORATORS_PATH = "/repos/MSWorkers/support.996.ICU/contributors?page=1&per_page=25"
    
    static private let ACCESS_TOKEN = "ACCESS_TOKEN"
    
    static func getContributors(callback: @escaping (GithibApiError?, AnyObject?) -> Void){
        var request = URLRequest(url: URL(string: API_ENDPOINT + COLLABORATORS_PATH)!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request){ data, response, error in
            processError(data: data, response: response, error: error, callback: callback)
            }.resume()
    }
    
    static func getContributorLocation(contributor: Contributor, callback: @escaping (GithibApiError?, AnyObject?) -> Void){
        var request = URLRequest(url: URL(string: contributor.url)!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request){ data, response, error in
            processError(data: data, response: response, error: error, callback: callback)
            }.resume()
    }
    
    private static func processError(data : Data?, response : URLResponse?, error : Error?, callback: @escaping (GithibApiError?, AnyObject?) -> Void){
        guard let data = data, error == nil else {
            DispatchQueue.main.async { callback(GithibApiError.apiError(message: error?.localizedDescription), nil) }
            return
        }
        
        let httpResponse = response as! HTTPURLResponse
        let json = try? JSONSerialization.jsonObject(with: data, options: []) as AnyObject
        
        DispatchQueue.main.async {
            if httpResponse.statusCode != 200 {
                callback(GithibApiError.serverError(errorCode: httpResponse.statusCode), json)
            } else {
                callback(nil, json)
            }
        }
    }
    
    
}
