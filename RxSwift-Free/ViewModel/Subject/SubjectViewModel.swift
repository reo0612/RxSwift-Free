
import Foundation
import RxSwift
import RxCocoa

protocol SubjectViewModelInput {
    var viewWillApperObserver: AnyObserver<Void> { get }
    var switchObserver: AnyObserver<Bool> { get }
}

protocol SubjectViewModelOutput {
    var textObservable: Observable<String> { get }
    var isOnObservable: Observable<Bool> { get }
}

final class SubjectViewModel: SubjectViewModelInput, SubjectViewModelOutput {
    var viewWillApperObserver: AnyObserver<Void>
    var switchObserver: AnyObserver<Bool>
    var textObservable: Observable<String>
    var isOnObservable: Observable<Bool>
    
    init() {
        // subjectはイベントを発生させてしまうので非公開にし、Observableで外部に公開する
        
        let _textObservable = PublishSubject<String>()
        self.textObservable = _textObservable.asObservable()
        self.viewWillApperObserver = .init(eventHandler: { event in
            guard let event = event.element else { return }
            print(event)
            // 値を発生させている
            _textObservable.onNext("event")
        })
        
        let _isOnObservable = BehaviorSubject<Bool>(value: false)
        self.isOnObservable = _isOnObservable.asObservable()
        self.switchObserver = .init(eventHandler: { event in
            guard let event = event.element else { return }
            // 直前に渡された値を保持し、subscribeされた際にその値(初回の場合は初期値)を流す
            // 今回はUISwitchのON/OFFでBool値を変更させている
            // このように何らかの挙動があった時に直前に渡された値を保持し、それを外部に通知する事が可能
            _isOnObservable.onNext(event)
        })
    }
    
    
}
