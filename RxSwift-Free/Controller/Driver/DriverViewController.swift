
import UIKit
import RxSwift
import RxCocoa

// RxCococaが提供するDriverについて

// Observableの派生であり、以下の特徴がある
// ・メインスレッドで通知される
// ・Hot変換される
// ・onErrorを通知しない

// どういう場面で使うのかというと、UI部品での更新
// UI部品の値はonErrorで伝える必要はない

final class DriverViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    


}
