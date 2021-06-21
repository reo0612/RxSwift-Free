
import UIKit
import RxSwift
import RxCocoa

// ***** Driver *****

// RxCocoaが提供している

// Observableの派生であり、以下の特徴がある
// ・メインスレッドで通知される
// ・Hot変換される
// ・エラーが起きても処理の流れが途切れない

final class DriverViewController: UIViewController {

    @IBOutlet weak private var label: UILabel!
    @IBOutlet weak private var button: UIButton!
    
    private var viewModel = DriverViewModel()
    private lazy var input: DriverViewModelInput = viewModel
    private lazy var output: DriverViewModelOutput = viewModel
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        
        // Driverの作り方
        // 1.create系のOperatorを利用する
        // 2.Observableから変換する
        
        // Driverにもcreate, just, ofなどのOperatorが用意されている
        
        // asDriver()によってObservaleをDriverにできる
        // DriverではsubscribeではなくdriveやdriveNextを利用する
        // 注意点として、これらはメインスレッドでしか呼べない
        button.rx.tap.asDriver().drive(input.tapObserver).disposed(by: disposeBag)
        
        // ObservableをDriverに変換するメソッドは３つ用意されている
        // 1つ目 エラーが発生時に指定した Driver のイベントを通知するバージョン
        //output.changeTextObservable.asDriver(onErrorDriveWith: Driver.empty()).drive(label.rx.text).disposed(by: disposeBag) // エラーを無視
        
        // 2つ目 エラーが発生したら指定した値を通知するバージョン
        // output.changeTextObservable.asDriver(onErrorJustReturn: "error").drive(label.rx.text).disposed(by: disposeBag)
        
        // 3つ目 エラー内容に応じて処理を切り替えられるバージョン
        output.changeTextObservable.asDriver {[weak self] error in
            print(error.localizedDescription)
            // エラーであれば"error"を通知した後に、onCompletedを流す
            return Driver.just("error")

        }.drive(label.rx.text).disposed(by: disposeBag)
        
        // 使いどころとしては、`UI部品の更新`で使われる
        
        // UIの処理部はメインスレッドで行う必要があるので
        // 非同期処理で取得したデータを取得した場合は、この処理が終わった後にUIに伝える必要がある
        
        // もし、非同期処理中に何らかのエラーが起きた時にはUIに適用する前にエラーを処理し
        // クラッシュやUI側の処理が正しく行われるようにしなくてはならない
        
        // こういう時にDriverを使用する
        // Driverであれば、エラーが起きても処理の流れが途切れないし
        // さらにメインスレッドで常に通知するのでUI部品の更新に適している
    }
}

// DriverのHot変換ではshareReplayLatestWhileConnectedを内部で使用している
// これはshareReplay(1)とほぼ同じだがconnect()中でないと最後の値が取れない
// つまり、一度でもcompletedが流れたら、その後にはreplayされず、completedしか流れない

// 因みにshareReplay(1)は publish + refCount + replay である
// つまり「Hotだが最初にsubscribeされるまで動作しない」を守りつつ指定された個数だけ値をreplayする

// publish:
// publishSubjectにmulticastする

// multicast:
// Subjectを指定し、そこで一旦イベントを受けるようにしている

// refCount:
// HotなObservableだが最初に、subscribeされるまで動作しない
// subscribeしているものをカウントしており、disposeする度に内部カウントをデクリメントする
// 内部カウンターの値が0になると、connect()したものをdisposeする

// replay:
// ConnectableObservableの変換

// そもそもHot変換というのは内部でSubjectを利用し、connectableObservableに変換していることを指す
// そして、connect()を呼ぶことによって動作する

// 例:
// let observable = Observable.of(1, 2, 3).publish()
// observable.connect().disposed(by: disposeBag)

// 出力結果:
// 1
// 2
// 3
