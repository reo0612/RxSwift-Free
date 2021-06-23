
import UIKit
import RxSwift
import RxCocoa

// ***** Single *****

// 値かエラーのどちらか１つを流すObservable

// 一度、イベントを送信するとdisposeされる

// Single.createした場合、SingleEventを返すようになっているが
// Result型のようにsuccess・errorのみ定義されている

// successであれば、値を送信した後に即座にcompletedが送信される
// errorであれば、errorを送信したのち、disposeされる

// API通信など1回で完結する処理に向いている

final class SingleViewController: UIViewController {
    
    @IBOutlet weak private var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: SingleTableViewCell.className, bundle: nil), forCellReuseIdentifier: SingleTableViewCell.className)
        }
    }
    
    private var viewModel: SingleViewModel = SingleViewModel()
    private lazy var input: SingleViewModelInput = viewModel
    private lazy var output: SingleViewModelOutput = viewModel
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        rx.viewWillAppear.bind(to: input.viewWillApperObserver).disposed(by: disposeBag)
        
        output.githubObservable.bind(to: tableView.rx.items(cellIdentifier: SingleTableViewCell.className, cellType: SingleTableViewCell.self)) {[weak self] _, element, cell in
            cell.configure(githubModel: element)
            
        }.disposed(by: disposeBag)
        
        output.errorObservable.subscribe {[weak self] error in
            guard let error = error.element else { return }
            print(error.localizedDescription)
            
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(GithubModel.self).subscribe {[weak self] githubModel in
            guard
                let self = self,
                let githubModel = githubModel.element,
                let url = URL(string: githubModel.htmlUrl) else { return }
            
            print(url as Any)
            Router.showWeb(vc: self, url: url)
            
        }.disposed(by: disposeBag)
    }

}
