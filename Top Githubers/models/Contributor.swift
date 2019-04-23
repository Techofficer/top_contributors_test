import Foundation

struct Contributor {
    let id : Int!
    let name : String!
    let numberOfCommits : Int!
    let image : String?
    let url : String!
    
    init(json : [String:Any?]){
        id = (json["id"] as! Int)
        name = (json["login"] as! String)
        url = (json["url"] as! String)
        numberOfCommits = (json["contributions"] as! Int)
        image = json["avatar_url"] as? String
    }
    
}
