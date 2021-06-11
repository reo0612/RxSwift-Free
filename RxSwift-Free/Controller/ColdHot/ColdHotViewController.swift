
import UIKit
import RxSwift
import RxCocoa
import RxOptional

// Cold・Hotの例
// textFieldに入力した値が2つのラベルに表示される

final class ColdHotViewController: UIViewController {

    @IBOutlet weak private var textField1: UITextField!
    
    @IBOutlet weak private var label1: UILabel!
    @IBOutlet weak private var label2: UILabel!
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    func bind() {
        // そのまま表示する
        
//         textField1.rx.text.bind(to: label1.rx.text).disposed(by: disposeBag)
//         textField1.rx.text.bind(to: label2.rx.text).disposed(by: disposeBag)
        
        // そのまま表示せずにイベントを加工して表示する
        // その結果、文字に変更を加えるたびにmap内の処理が2回呼ばれてしまっている
        
        // textField(Hot) -> map(Cold)
//        let observable = textField1.rx.text.map { text -> String in
//            print("map \(text ?? "")")
//            return "*\(text ?? "")*"
//        }
//        observable.bind(to: label1.rx.text).disposed(by: disposeBag)
//        observable.bind(to: label2.rx.text).disposed(by: disposeBag)
        
        // 何故、2回呼ばれてしまうのかというと"Cold Observable"になっているから
        // 2つのオブジェクトにバインドして購読すると別々の2本のストリームが生成されてしまう
        
        // 今回のようなラベルに表示するだけの軽い処理ならいいが
        // 通信処理などが含まれると、2回実行されると困る
        
        // ではどうすれば良いのかというと"Hot Observable"に変換すれば解決する
        // 変換するやり方として"Hot変換オペレータ"を使用する
        
        // textField(Hot) -> map(Cold) -> publish(Hot)
        let observable = textField1.rx.text.filterNil().map { text -> String in
            print("\(text.count)")
            return String(describing: text.count)
        }
        .publish()

        observable.bind(to: label1.rx.text).disposed(by: disposeBag)
        observable.bind(to: label2.rx.text).disposed(by: disposeBag)

        observable.connect().disposed(by: disposeBag)
        
        // 変換することによってtextFieldの1の変更に対して
        // map内の処理が1回ずつ呼ばれている
    }
}
