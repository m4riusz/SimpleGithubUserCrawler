import Foundation
import Reachability

class NetworkUtil {
    
    fileprivate let reachability: Reachability = Reachability()!
    
    var connectionChange: ((Bool) -> Void)? {
        didSet {
            reachability.whenReachable = { reachability in
                self.connectionChange?(true)
            }
            reachability.whenUnreachable = {_ in
                self.connectionChange?(false)
            }
        }
    }
    
    func startMonitoring() -> Void {
        do{
            try reachability.startNotifier()
        } catch {
            NSLog("Could not start reachability notifier")
        }
    }
    
    func stopMonitoring() -> Void {
        reachability.stopNotifier()
    }
    
    func hasConnection() -> Bool {
        return reachability.connection != .none
    }

}
