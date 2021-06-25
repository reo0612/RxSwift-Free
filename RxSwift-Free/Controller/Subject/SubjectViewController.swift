
import UIKit
import RxSwift
import RxCocoa
import RxOptional

// ***** Subject *****

// Subjectはイベントを受け取ることもできるし、イベントを発生させることもできる
// Observableでもあり、Observerでもある(例外もある)
// つまり、イベントの検知及び発生が可能なObservableの派生である

// 元のObservable同様３つのイベントを流せる(onNext, onError, onCompleted)

final class SubjectViewController: UIViewController {
    
    @IBOutlet weak private var label: UILabel!
    @IBOutlet weak private var `switch`: UISwitch!
    
    // Observable・Observerを準拠している
    private var publishSubject = PublishSubject<String>() // 初期値を持たない
    private var behaviorSubject = BehaviorSubject<Bool>(value: false) // 初期値を持つ
    
    // Observerを準拠していない
    private var replaySubject = ReplaySubject<String>.create(bufferSize: 2) // subscribe時にbufferSize分、過去のeventを受け取れる
    private var allReplaySubject = ReplaySubject<String>.createUnbounded() // subscribe時に、過去の全てのイベントが受け取れる
    
    // 続きはViewModelにて
    private var viewModel = SubjectViewModel()
    private lazy var input: SubjectViewModelInput = viewModel
    private lazy var output: SubjectViewModelOutput = viewModel
    
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        //bind()
        //doReplaySubject()
        doAllReplaySubject()
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
    
    // ReplaySubjectの動き
    func doReplaySubject() {
        // nextイベントを流す
        replaySubject
            .onNext("event1")
        
        // subscribeし、出力する
        replaySubject
            .subscribe { event in
                print("1 \(event)")
                
            }.disposed(by: disposeBag)

        // 再度、nextイベントを流す
        // subscribe時に出力するようにしているのでこのイベントも出力される
        replaySubject
            .onNext("event2")
        
        // 新たにsubscribeした時
        // 指定したbufferSize分、過去のイベントが受け取れる
        replaySubject
            .subscribe { event in
                print("2 \(event)")
                
            }.disposed(by: disposeBag)
        
        // 出力結果
        // 1 next(event1)
        // 1 next(event2)
        // 2 next(event1) 過去のイベントを受け取っている！
        // 2 next(event2)
    }

    // ReplaySubject<>.createUnbounded()の動き
    func doAllReplaySubject() {
        allReplaySubject
            .onNext("event1")
        
        allReplaySubject
            .subscribe { event in
                print("1 \(event)")
                
            }.disposed(by: disposeBag)

        allReplaySubject
            .onNext("event2")
        
        allReplaySubject
            .onNext("event3")
        
        allReplaySubject
            .subscribe { event in
                print("2 \(event)")
                
            }.disposed(by: disposeBag)
        
        // ReplaySubjectのcreateUnbounded()は過去の全てのイベントが受け取れる
        
        // 出力結果
        // 1 next(event1)
        // 1 next(event2)
        // 1 next(event3)
        // 2 next(event1)
        // 2 next(event2)
        // 2 next(event3)
    }
    
}
