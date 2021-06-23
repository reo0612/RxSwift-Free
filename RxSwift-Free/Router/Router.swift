
import UIKit
import SafariServices

final class Router {
    static func showRoot(window: UIWindow) {
        let main = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! MainViewController
        let navMain = UINavigationController(rootViewController: main)
        window.rootViewController = navMain
        window.makeKeyAndVisible()
    }
    
    static func showColdHot(vc: UIViewController) {
        let coldHot = UIStoryboard(name: "ColdHot", bundle: nil).instantiateInitialViewController() as! ColdHotViewController
        vc.navigationController?.pushViewController(coldHot, animated: true)
    }
    
    static func showSubject(vc: UIViewController) {
        let subject = UIStoryboard(name: "Subject", bundle: nil).instantiateInitialViewController() as! SubjectViewController
        vc.navigationController?.pushViewController(subject, animated: true)
    }

    static func showRelay(vc: UIViewController) {
        let relay = UIStoryboard(name: "Relay", bundle: nil).instantiateInitialViewController() as! RelayViewController
        vc.navigationController?.pushViewController(relay, animated: true)
    }
    
    static func showDriver(vc: UIViewController) {
        let driver = UIStoryboard(name: "Driver", bundle: nil).instantiateInitialViewController() as! DriverViewController
        vc.navigationController?.pushViewController(driver, animated: true)
    }
    
    static func showSingle(vc: UIViewController) {
        let single = UIStoryboard(name: "Single", bundle: nil).instantiateInitialViewController() as! SingleViewController
        vc.navigationController?.pushViewController(single, animated: true)
    }
    
    static func showWeb(vc: UIViewController, url: URL) {
        let safari = SFSafariViewController(url: url)
        vc.present(safari, animated: true, completion: nil)
    }
}
