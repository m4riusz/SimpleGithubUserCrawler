import Foundation
import Cache

protocol ICacheConfig {
    func getMaxSize() -> UInt
    func getExpire() -> UInt
}

struct CacheConfig: ICacheConfig {
    let cacheSize: UInt
    let expireSeconds: UInt
    
    func getMaxSize() -> UInt { return cacheSize }
    func getExpire() -> UInt { return expireSeconds }
}

protocol ICacheManager {
    init(withDiscConfig discConfig: ICacheConfig, withMemoryConfig memoryConfig: ICacheConfig)
    func setCachedUser(userDetails: UserDetails) -> Void
    func getCachedUser(username: String?) -> UserDetails?
    func setCachedList(query: String, users: [User]) -> Void
    func getCachedList(query: String?) -> [User]?
}

class CacheManager: ICacheManager {
   
    fileprivate let usersStorage: Storage<[User]>
    fileprivate let usersDetailStorage: Storage<UserDetails>
    
    required init(withDiscConfig discConfig: ICacheConfig, withMemoryConfig memoryConfig: ICacheConfig) {
        let usersDiscConfig = DiskConfig(name: "disc_users",
                                     expiry: Expiry.seconds(TimeInterval(discConfig.getExpire())),
                                     maxSize: discConfig.getMaxSize(),
                                     directory: nil,
                                     protectionType: nil)
        let usersDetailDiscConfig = DiskConfig(name: "disc_detail_user",
                                         expiry: Expiry.seconds(TimeInterval(discConfig.getExpire())),
                                         maxSize: discConfig.getMaxSize(),
                                         directory: nil,
                                         protectionType: nil)
        let memoryConfig = MemoryConfig(expiry: Expiry.seconds(TimeInterval(memoryConfig.getExpire())),
                                         countLimit: 20,
                                         totalCostLimit: memoryConfig.getMaxSize())
       self.usersStorage = try! Storage(diskConfig: usersDiscConfig, memoryConfig: memoryConfig, transformer: TransformerFactory.forCodable(ofType: [User].self))
        self.usersDetailStorage = try! Storage(diskConfig: usersDetailDiscConfig, memoryConfig: memoryConfig, transformer: TransformerFactory.forCodable(ofType: UserDetails.self))
    }
    
    func setCachedUser(userDetails: UserDetails) -> Void {
        try? self.usersDetailStorage.setObject(userDetails, forKey: userDetails.login)
    }
    
    func getCachedUser(username: String?) -> UserDetails? {
        if username == nil {
            return nil
        }
        return try? self.usersDetailStorage.object(forKey: username!)
    }
    
    func setCachedList(query: String, users: [User]) -> Void{
        try? self.usersStorage.setObject(users, forKey: query)
    }
    
    func getCachedList(query: String?) -> [User]? {
        if query == nil {
            return nil
        }
        return try? self.usersStorage.object(forKey: query!)
    }
    
}
