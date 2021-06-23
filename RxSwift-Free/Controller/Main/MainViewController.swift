
import UIKit

final class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction private func showColdHot(_ sender: UIButton) {
        Router.showColdHot(vc: self)
    }
    
    @IBAction private func showSubject(_ sender: UIButton) {
        Router.showSubject(vc: self)
    }
    
    @IBAction private func showRelay(_ sender: UIButton) {
        Router.showRelay(vc: self)
    }
    
    @IBAction private func showDriver(_ sender: UIButton) {
        Router.showDriver(vc: self)
    }
    
    @IBAction private func showSingle(_ sender: UIButton) {
        Router.showSingle(vc: self)
    }
}

