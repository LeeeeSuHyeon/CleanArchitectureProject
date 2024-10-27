//
//  UserListItem.swift
//  CleanArchitectureProject
//
//  Created by 이수현 on 10/25/24.
//

import Foundation

public struct UserListResult : Decodable {
    let totalCount : Int
    let incompleteResults : Bool
    let items : [UserListItem]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.totalCount = try container.decode(Int.self, forKey: .totalCount)
        self.incompleteResults = try container.decode(Bool.self, forKey: .incompleteResults)
        self.items = try container.decode([UserListItem].self, forKey: .items)
    }
}

public struct UserListItem : Decodable{
    let id : Int
    let login : String
    let imageURL : String
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case imageURL = "avatar_url"
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.login = try container.decode(String.self, forKey: .login)
        self.imageURL = try container.decode(String.self, forKey: .imageURL)
    }
    
    public init(id : Int, login : String, imageURL : String) {
        self.id = id
        self.login = login
        self.imageURL = imageURL
    }
}



// https://docs.github.com/ko/rest/search/search?apiVersion=2022-11-28#search-users

/*
 
 "total_count": 11398,
 "incomplete_results": false,
 "items": [
 {
 "login": "q",
 "id": 65956,
 "node_id": "MDQ6VXNlcjY1OTU2",
 "avatar_url": "https://avatars.githubusercontent.com/u/65956?v=4",
 "gravatar_id": "",
 "url": "https://api.github.com/users/q",
 "html_url": "https://github.com/q",
 "followers_url": "https://api.github.com/users/q/followers",
 "following_url": "https://api.github.com/users/q/following{/other_user}",
 "gists_url": "https://api.github.com/users/q/gists{/gist_id}",
 "starred_url": "https://api.github.com/users/q/starred{/owner}{/repo}",
 "subscriptions_url": "https://api.github.com/users/q/subscriptions",
 "organizations_url": "https://api.github.com/users/q/orgs",
 "repos_url": "https://api.github.com/users/q/repos",
 "events_url": "https://api.github.com/users/q/events{/privacy}",
 "received_events_url": "https://api.github.com/users/q/received_events",
 "type": "User",
 "user_view_type": "public",
 "site_admin": false,
 "score": 1
 },
 
 */
