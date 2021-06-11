
import UIKit
import RxSwift
import RxCocoa
import RxOptional

// Subjectの例

// Subjectはイベントを受け取ることもできるし、イベントを発生させることもできる
// Observableでもあり、Observerでもある
// つまり、イベントの検知及び発生が可能なObservableの派生である

// 元のObservable同様３つのイベントを流せる(onNext, onError, onCompleted)

final class SubjectViewController: UIViewController {
    
    @IBOutlet weak private var label: UILabel!
    @IBOutlet weak private var `switch`: UISwitch!
    // 2種類ある
    //private var publishSubject = PublishSubject<String>() // 初期値を持たない
    //private var behaviorSubject = BehaviorSubject<Bool>(value: false) // 初期値を持つ
    
    // 続きはViewModelにて
    private var viewModel = SubjectViewModel()
    private lazy var input: SubjectViewModelInput = viewModel
    private lazy var output: SubjectViewModelOutput = viewModel
    
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    func bind() {
        // 入力
        rx.viewWillAppear.bind(to: input.viewWillApperObserver).disposed(by: disposeBag)
        `switch`.rx.isOn.bind(to: input.switchObserver).disposed(by: disposeBag)
        
        // 出力
        output.textObservable.subscribe {[weak self] text in
            guard let text = text.element else { return }
            print(text)
            self?.label.text = text
            
        }.disposed(by: disposeBag)
        
        output.isOnObservable.subscribe {[weak self] in
            guard let isOn = $0.element else { return }
            print(isOn)
            self?.label.text = isOn ? "true": "false"
            
        }.disposed(by: disposeBag)
    }
    
}
