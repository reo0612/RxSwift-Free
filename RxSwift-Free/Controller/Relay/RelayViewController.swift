
import UIKit
import RxSwift
import RxCocoa

// Relayの例

// Subjectのラッパークラスであり、onNextイベントのみ流せる
// つまり、onErrorやcompletedが流れてこないことを保証する

// Subject同様、PublishとBehaviorの2種類あり、仕組みは同じ
// 違いとしては、RelayクラスにはObserverTypeに準拠していない

final class RelayViewController: UIViewController {
    
    @IBOutlet weak private var label: UILabel!
    @IBOutlet weak private var `switch`: UISwitch!
    
    private var viewModel = RelayViewModel()
    private lazy var input: RelayViewModelInput = viewModel
    private lazy var output: RelayViewModelOutput = viewModel
    
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    func bind() {
        `switch`.rx.isOn.bind(to: input.switchObserver).disposed(by: disposeBag)
        
        output.isOnObservable.subscribe {[weak self] isOn in
            guard let isOn = isOn.element else { return }
            self?.label.text = isOn ? "true": "false"
            print(isOn)
            
        }.disposed(by: disposeBag)
    }

}
