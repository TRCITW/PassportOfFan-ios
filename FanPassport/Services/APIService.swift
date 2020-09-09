//
//  APIService.swift
//
//  Created by Vadim on 04/09/2019.
//  Copyright © 2019 Vadim-S. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import AlamofireNetworkActivityLogger

class APIService {
    
    var requestManager = Alamofire.SessionManager.default
    let imageCache = AutoPurgingImageCache()
    let firService = FirebaseAuthService()
    let baseUrlString = "http://portal.autoimport62.ru/api/"
    let baseImageURL = ""
    var params: [String: String] {
        return [:]
    }
 
    var headers: [String: String] {
        if let token = UserDefaults.standard.string(forKey: UserKeys.apiToken) {
            return ["Accept": "application/json", "Authorization": "Bearer \(token)"]
        } else {
            return ["Accept": "application/json"]
        }
    }
    
    init() {
        let cfg = Alamofire.SessionManager.default.session.configuration
        requestManager = Alamofire.SessionManager(configuration: cfg)
        NetworkActivityLogger.shared.level = .debug
        NetworkActivityLogger.shared.startLogging()
    }
    
    // MARK: - network connection
    func isInternetAvailable(vc: UIViewController) -> Bool {
        let isReachable = NetworkReachabilityManager()!.isReachable
        if !isReachable {
            let alert = UIAlertController(title: "Нет соединения с интернетом", message: "Попробуйте повторить операцию позже", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Ок", style: .cancel, handler: nil))
            vc.present(alert, animated: true, completion: nil)
        }
        return isReachable
    }
    
    func getNetworkStatus() -> Alamofire.NetworkReachabilityManager.NetworkReachabilityStatus {
        let status = NetworkReachabilityManager()!.networkReachabilityStatus
        return status
    }
    
    func startListeningNetworkChanges() {
        NetworkReachabilityManager()!.startListening()
    }
    
    func stopListeningNetworkChanges() {
        NetworkReachabilityManager()!.stopListening()
    }
    
    // MARK: - work with images and cache
    func setImageInCache(imageName:String, completion: @escaping (Bool)->()) {
        if let _ = imageCache.image(withIdentifier: imageName) {
            completion(true)
        } else {
            requestManager.request(imageName).responseImage { response in
                if let image = response.result.value {
                    self.imageCache.add(image, withIdentifier: imageName)
                    completion(true)
                }
                completion(false)
            }
        }
    }
    
    func getImageFromCache(imageName:String) -> UIImage {
        if let cachedImage = imageCache.image(withIdentifier: imageName) {
            return cachedImage
        } else {
            return UIImage()
        }
    }
    
    // MARK: - Firebase servises
    func codeConfirm(code: String, completion: @escaping (Bool)->()) {
        firService.codeValidate(code: code) { result in
            completion(result)
        }
    }
    
    func firebaseAuthorization(phone: String, completion: @escaping (Bool, Error?)->()) {
        firService.authorization(with: phone) { result, error in
            completion(result, error)
        }
    }
    
    // MARK: - api servises
    // MARK: - Авторизация пользователя (на основе firebase)
    func postAuth(completion: @escaping (Bool, LoginResponse?, ResponseError?)->()) {
        
        var reqParams = params
        reqParams["phone"] = UserDefaults.standard.string(forKey: UserKeys.phone)
        reqParams["uid"] = UserDefaults.standard.string(forKey: UserKeys.firebaseUID)
        reqParams["token"] = UserDefaults.standard.string(forKey: UserKeys.fcmToken)

        self.requestManager.request(self.baseUrlString + "user/fb/login",
                                  method: .post,
                                  parameters: reqParams,
                                  encoding: JSONEncoding.default,
                                  headers: self.headers).validate().responseJSON { response in
        
                                   switch response.result {
                                   case .success(let value):
                                       if let code = response.response?.statusCode {
                                           switch code {
                                            case 200:
                                               let obj = LoginResponse(dictionary: value as? [String : AnyObject] ?? [:])
                                               UserDefaults.standard.set(obj.user?.id, forKey: UserKeys.id)
                                               UserDefaults.standard.set(obj.user?.apiToken, forKey: UserKeys.apiToken)
                                               UserDefaults.standard.set(obj.user?.avatar, forKey: UserKeys.avatar)
                                               UserDefaults.standard.set(obj.user?.name, forKey: UserKeys.name)
                                               UserDefaults.standard.set(obj.user?.mail, forKey: UserKeys.email)
                                               UserDefaults.standard.set(obj.user?.lastname, forKey: UserKeys.surname)
                                               UserDefaults.standard.set(obj.user?.secondname, forKey: UserKeys.secondName)
                                               UserDefaults.standard.set(obj.user?.gender, forKey: UserKeys.sex)
                                               UserDefaults.standard.synchronize()
                                               if let img = UserDefaults.standard.string(forKey: UserKeys.avatar) {
                                                    self.setImageInCache(imageName: img){response in}
                                               }
                                               
                                               completion(true, obj, nil)
                                           
                                            case 401, 429:
                                               completion(false, nil, self.responseError(errorInfo: response))
                                               
                                            default: break
                                           }
                                       }
              
                                   case .failure(_):
                                       completion(false, nil, self.responseError(errorInfo: response))
                                   }
           }
    }
    
    // Создание нового пользователя (на основе firebase)
   func postUser(completion: @escaping (Bool, ResponseError?)->()) {
        
        var reqParams = params
        reqParams["name"] = UserDefaults.standard.string(forKey: UserKeys.name)
        reqParams["email"] = UserDefaults.standard.string(forKey: UserKeys.email)
        reqParams["phone"] = UserDefaults.standard.string(forKey: UserKeys.phone)
        reqParams["uid"] = UserDefaults.standard.string(forKey: UserKeys.firebaseUID)
        reqParams["token"] = UserDefaults.standard.string(forKey: UserKeys.fcmToken)

        self.requestManager.request(self.baseUrlString + "user/fb/save",
                                  method: .post,
                                  parameters: reqParams,
                                  encoding: JSONEncoding.default,
                                  headers: self.headers).validate().responseJSON { response in
        
                                   switch response.result {
                                   case .success(_):
                                       if let code = response.response?.statusCode {
                                           switch code {
                                            case 200:
                                               completion(true, nil)
                                           
                                            case 401, 429:
                                               completion(false, self.responseError(errorInfo: response))
                                               
                                            default: break
                                           }
                                       }
              
                                   case .failure(_):
                                       completion(false, self.responseError(errorInfo: response))
                                   }
        }
    }
    
    // MARK: - Проверка пользователя на существование
    func postIsset(phone: String, completion: @escaping (Bool, LoginResponse?, ResponseError?)->()) {

        self.requestManager.request(self.baseUrlString + "numisreg/" + phone.replacingOccurrences(of: "+", with: ""),
                                  method: .get,
                                  headers: self.headers).validate().responseJSON { response in
        
                                   switch response.result {
                                   case .success(let value):
                                       if let code = response.response?.statusCode {
                                           switch code {
                                            case 200:
                                               let obj = LoginResponse(dictionary: value as? [String : AnyObject] ?? [:])
                                               completion(true, obj, nil)
                                           
                                            case 401, 429:
                                               completion(false, nil, self.responseError(errorInfo: response))
                                               
                                            default: break
                                           }
                                       }
              
                                   case .failure(_):
                                       completion(false, nil, self.responseError(errorInfo: response))
                                   }
           }
    }
       
    // Регистрация
    func postUserRegistration(completion: @escaping (Bool, ResponseError?)->()) {
        
        var reqParams = params
        reqParams["phone"] = UserDefaults.standard.string(forKey: UserKeys.phone)
        reqParams["name"] = UserDefaults.standard.string(forKey: UserKeys.name)
        reqParams["lastname"] = UserDefaults.standard.string(forKey: UserKeys.surname)
        reqParams["secondname"] = UserDefaults.standard.string(forKey: UserKeys.secondName)
        reqParams["imei"] = UserDefaults.standard.string(forKey: UserKeys.firebaseUID)

        self.requestManager.request(self.baseUrlString + "reg/",
                                  method: .post,
                                  parameters: reqParams,
                                  encoding: JSONEncoding.default,
                                  headers: self.headers).validate().responseJSON { response in
        
                                   switch response.result {
                                   case .success(_):
                                       if let code = response.response?.statusCode {
                                           switch code {
                                            case 200:
                                               completion(true, nil)
                                           
                                            case 401, 429:
                                               completion(false, self.responseError(errorInfo: response))
                                               
                                            default: break
                                           }
                                       }
              
                                   case .failure(_):
                                       completion(false, self.responseError(errorInfo: response))
                                   }
           }
    }

    
    // Добавление данных о отсидке на мероприятии
    // Отправка резуоттатов отсидки после окончания события, делается только 1 раз
    func postAddTime(idaction: Int, totaltime: Int, completion: @escaping (Bool, ResponseError?)->()) {

        var reqParams = params
        reqParams["idaction"] = idaction.description
        reqParams["idfun"] = UserDefaults.standard.string(forKey: UserKeys.id)
        reqParams["totaltime"] = totaltime.description
        reqParams["phone"] = UserDefaults.standard.string(forKey: UserKeys.phone)
        reqParams["imei"] = UserDefaults.standard.string(forKey: UserKeys.firebaseUID)
        reqParams["token"] = UserDefaults.standard.string(forKey: UserKeys.firebaseUID)

        requestManager.request(baseUrlString + "load/",
                               method: .post,
                               parameters: reqParams,
                               headers: headers).validate().responseJSON { response in
                                
                                if let data = response.data, let str = String(data: data, encoding: .utf8){
                                    print(str)
                                }

                                switch response.result {
                                case .success(_):
                                    if let code = response.response?.statusCode {
                                        switch code {
                                         case 200:
                                            completion(true, nil)

                                         case 401, 429:
                                            completion(false, self.responseError(errorInfo: response))

                                         default: break
                                        }
                                    }

                                case .failure(_):
                                    completion(false, self.responseError(errorInfo: response))
                                }
        }
    }
    
    
    // Получение новостей
    func getActions(completion: @escaping (Bool, [Action]?, ResponseError?)->()) {

        requestManager.request(baseUrlString + "actions/",
                               method: .get,
                               parameters: params).validate().responseJSON { response in

                                switch response.result {
                                case .success(let value):
                                    if let code = response.response?.statusCode {
                                        switch code {
                                         case 200:
                                            var actions = [Action]()
                                            if let array = value as? [[String : AnyObject]] {
                                                for elem in array {
                                                    let obj = Action(dictionary: elem)
                                                    actions.append(obj)
                                                }
                                            }
                                            completion(true, actions, nil)

                                         case 401, 429:
                                            completion(false, nil, self.responseError(errorInfo: response))

                                         default: break
                                        }
                                    }

                                case .failure(_):
                                    if let code = response.response?.statusCode {
                                        switch code {
                                         case 200:
                                            print(response.result)
                                            completion(false, nil, self.responseError(errorInfo: response))

                                         default:
                                            completion(false, nil, self.responseError(errorInfo: response))
                                        }
                                    }
                                }
        }
    }
    
    // Получение рейтингов всех пользователей
    func getRatings(completion: @escaping (Bool, [Rating]?, ResponseError?)->()) {

        requestManager.request(baseUrlString + "rating/",
                               method: .get,
                               parameters: params).validate().responseJSON { response in

                                switch response.result {
                                case .success(let value):
                                    if let code = response.response?.statusCode {
                                        switch code {
                                         case 200:
                                            var actions = [Rating]()
                                            if let array = value as? [[String : AnyObject]] {
                                                for elem in array {
                                                    let obj = Rating(dictionary: elem)
                                                    actions.append(obj)
                                                }
                                            }
                                            completion(true, actions, nil)

                                         case 401, 429:
                                            completion(false, nil, self.responseError(errorInfo: response))

                                         default: break
                                        }
                                    }

                                case .failure(_):
                                    completion(false, nil, self.responseError(errorInfo: response))
                                }
        }
    }
    
    // Получение рейтинга пользователя
    func getUserRating(completion: @escaping (Bool, [UserStatistic]?, ResponseError?)->()) {

        requestManager.request(baseUrlString + "rating/" + UserDefaults.standard.integer(forKey: UserKeys.id).description,
                               method: .get,
                               parameters: params,
                               headers: headers).validate().responseJSON { response in

                                switch response.result {
                                case .success(let value):
                                    if let code = response.response?.statusCode {
                                        switch code {
                                         case 200:
                                            var actions = [UserStatistic]()
                                            if let array = value as? [[String : AnyObject]] {
                                                for elem in array {
                                                    let obj = UserStatistic(dictionary: elem)
                                                    actions.append(obj)
                                                }
                                            }
                                            completion(true, actions, nil)

                                         case 401, 429:
                                            completion(false, nil, self.responseError(errorInfo: response))

                                         default: break
                                        }
                                    }

                                case .failure(_):
                                    completion(false, nil, self.responseError(errorInfo: response))
                                }
        }
    }
    
    // Получение подробной информации о пользователе
    func getUser(completion: @escaping (Bool, ResponseError?)->()) {

        requestManager.request(baseUrlString + "fun/" + (UserDefaults.standard.object(forKey: UserKeys.phone) as? String ?? ""),
                               method: .get,
                               parameters: params,
                               headers: headers).validate().responseJSON { response in

                                switch response.result {
                                case .success(let value):
                                    if let code = response.response?.statusCode {
                                        switch code {
                                         case 200:
                                            let obj = User(dictionary: value as? [String : AnyObject] ?? [:])
                                            UserDefaults.standard.set(obj.id, forKey: UserKeys.id)
                                            UserDefaults.standard.set(obj.apiToken, forKey: UserKeys.apiToken)
                                            UserDefaults.standard.set(obj.avatar, forKey: UserKeys.avatar)
                                            UserDefaults.standard.set(obj.name, forKey: UserKeys.name)
                                            UserDefaults.standard.set(obj.mail, forKey: UserKeys.email)
                                            UserDefaults.standard.set(obj.lastname, forKey: UserKeys.surname)
                                            UserDefaults.standard.set(obj.secondname, forKey: UserKeys.secondName)
                                            UserDefaults.standard.set(obj.gender, forKey: UserKeys.sex)
                                            UserDefaults.standard.synchronize()
                                            if let img = UserDefaults.standard.string(forKey: UserKeys.avatar) {
                                                 self.setImageInCache(imageName: img){response in}
                                            }
                                            completion(true, nil)

                                         case 401, 429:
                                            completion(false, self.responseError(errorInfo: response))

                                         default: break
                                        }
                                    }

                                case .failure(_):
                                    completion(false, self.responseError(errorInfo: response))
                                }
        }
    }
    

    func responseError(errorInfo: DataResponse<Any>, message: String = "") -> ResponseError{
        let objError = ResponseError()
        objError.meta = errorInfo as AnyObject
        objError.code = errorInfo.response?.statusCode
        if message == "" {
            let errorMessage = Messages()
            errorMessage.type = "handle"
            errorMessage.text = "Ошибка выполнения запроса"
            objError.messages = [errorMessage]
        }
        return objError
    }
    
    func responseError(message: String = "") -> ResponseError{
        let objError = ResponseError()
        let errorMessage = Messages()
        errorMessage.type = "handle"
        errorMessage.text = "Ошибка выполнения запроса"
        objError.messages = [errorMessage]
        return objError
    }
}
