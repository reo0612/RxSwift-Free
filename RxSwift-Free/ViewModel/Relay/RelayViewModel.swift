
import Foundation
import RxSwift
import RxCocoa

protocol RelayViewModelInput {
    var switchObserver: AnyObserver<Bool> { get }
}

protocol RelayViewModelOutput {
    var isOnObservable: Observable<Bool> { get }
}

final class RelayViewModel: RelayViewModelInput, RelayViewModelOutput {
    var switchObserver: AnyObserver<Bool>
    var isOnObservable: Observable<Bool>
    
    init() {
        // Subject同様でRelayも公開はしない
        
        let _isOnObservable = BehaviorRelay<Bool>(value: false)
        self.isOnObservable = _isOnObservable.asObservable()
        switchObserver = .init(eventHandler: { event in
            guard let event = event.element else { return }
            // RelayではacceptでonNextイベントを流す
            _isOnObservable.accept(event)
        })
    }
}
