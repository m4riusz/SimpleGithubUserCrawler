import Foundation
import Alamofire

struct UserResponse: Codable {
    
    let totalCount: UInt?
    let incompleteResults: Bool?
    let items: [User]?
    
    enum CodingKeys : String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

protocol IUsersService {
    
    func getUsersByQuery(_ query: String?, withCompletionBlock: @escaping ([User]) -> Void, withErrorBlock:@escaping (Error) -> Void) -> Void
    
    func getUserDetailsByLogin(_ login: String, withCompletionBlock: @escaping (UserDetails) -> Void, withErrorBlock:@escaping (Error) -> Void) -> Void
}

class UsersService: IUsersService {

    let baseUrl: String = "https://api.github.com/"
    
    func getUsersByQuery(_ query: String?, withCompletionBlock completionBlock: @escaping ([User]) -> Void, withErrorBlock errorBlock: @escaping (Error) -> Void) -> Void {
        var searchQuery: String = "\(baseUrl)search/users"
        if (query != nil && !query!.isEmpty) {
            searchQuery.append("?q=\(query!)")
        }
        Alamofire.request(searchQuery , method: .get).responseJSON(queue: DispatchQueue.global(qos: .userInitiated)) { response in
            if let error = response.error {
                errorBlock(error);
                return
            }
            do {
                let users: UserResponse = try JSONDecoder().decode(UserResponse.self, from: response.data!)
                completionBlock(users.items ?? [])
            } catch let error {
                errorBlock(error)
            }
        }
    }
    
    func getUserDetailsByLogin(_ login: String, withCompletionBlock completionBlock: @escaping (UserDetails) -> Void, withErrorBlock errorBlock: @escaping (Error) -> Void) {
        let urlQuery: String = "\(baseUrl)users/\(login)"
        Alamofire.request(urlQuery , method: .get).responseJSON(queue: DispatchQueue.global(qos: .userInitiated)) { response in
            if let error = response.error {
                errorBlock(error);
                return
            }
            do {
                let userDetail: UserDetails = try JSONDecoder().decode(UserDetails.self, from: response.data!)
                completionBlock(userDetail)
            } catch let error {
                errorBlock(error)
            }
        }
    }
    
    
}
