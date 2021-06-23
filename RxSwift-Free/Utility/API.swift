
import Foundation
import RxSwift
import Alamofire
import RxCocoa

final class API {
    static let shared = API()
    private init() {}
    
    private let host = "https://api.github.com"
    
    func get() -> Single<[GithubModel]> {
        let endPoint = "/search/repositories"
        let param = "q=swift"
        
        let headers: HTTPHeaders = [
            "accept": "application/vnd.github.v3+json"
        ]
        
        return Single.create { observer -> Disposable in
            guard let url = URL(string: self.host + endPoint + "?" + param) else {
                // イベントの購読を解除する
                return Disposables.create()
            }
            print(url as Any)
            let request = AF.request(url, method: .get, headers: headers).responseJSON { responce in
                if let error = responce.error {
                    observer(.failure(error))
                }
                
                guard let data = responce.data else {
                    // 自作エラーで対応したり
                    return
                }
                
                do {
                    let decodeData = try JSONDecoder().decode(GithubResponce.self, from: data)
                    let githubModels = decodeData.items
                    observer(.success(githubModels))
                    
                }catch let error {
                    observer(.failure(error))
                }
            }
            return Disposables.create() { request.cancel() }
        }
    }
}
