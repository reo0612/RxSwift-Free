
import Foundation
import RxSwift
import RxCocoa
import NSObject_Rx

protocol SingleViewModelInput {
    var viewWillApperObserver: AnyObserver<Void> { get }
}

protocol SingleViewModelOutput {
    var githubObservable: Observable<[GithubModel]> { get }
    var errorObservable: Observable<Error> { get }
}

final class SingleViewModel: HasDisposeBag, SingleViewModelInput, SingleViewModelOutput {
    var viewWillApperObserver: AnyObserver<Void>
    
    var githubObservable: Observable<[GithubModel]>
    var errorObservable: Observable<Error>
        
    init() {
        // 入力側
        let viewWillApper = PublishRelay<Void>()
        self.viewWillApperObserver = .init(eventHandler: { event in
            guard let event = event.element else { return }
            viewWillApper.accept(event)
        })
        
        // 出力側
        let _githubObservable = PublishRelay<[GithubModel]>()
        self.githubObservable = _githubObservable.asObservable()
        let _errorObservable = PublishRelay<Error>()
        self.errorObservable = _errorObservable.asObservable()
       
        viewWillApper.asObservable().subscribe {[weak self] _ in
            guard let self = self else { return }
            API.shared.get().subscribe {[weak self] githubModels in
                guard let self = self else { return }
                _githubObservable.accept(githubModels)
                
            } onFailure: { error in
                _errorObservable.accept(error)
                
            }.disposed(by: self.disposeBag)

        }.disposed(by: disposeBag)
    }
}
