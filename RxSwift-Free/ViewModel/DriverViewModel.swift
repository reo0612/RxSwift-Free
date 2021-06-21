
import Foundation
import RxSwift
import RxCocoa
import NSObject_Rx

protocol DriverViewModelInput {
    var tapObserver: AnyObserver<Void> { get }
}

protocol DriverViewModelOutput {
    var changeTextObservable: Observable<String> { get }
}

final class DriverViewModel: DriverViewModelInput, DriverViewModelOutput, HasDisposeBag {
    var tapObserver: AnyObserver<Void>
    var changeTextObservable: Observable<String>
        
    init() {
        let tap = PublishRelay<Void>()
        
        self.tapObserver = .init(eventHandler: { event in
            guard let event = event.element else { return }
            tap.accept(event)
        })

        self.changeTextObservable = tap.map({ tap -> String in
            return "event"
            
        }).asObservable()
    }
    
}
