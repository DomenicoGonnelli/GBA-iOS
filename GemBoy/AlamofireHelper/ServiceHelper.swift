//
//  ServiceHelper.swift
//  Project
//
//  Created by EGONNEDGJ on 16/02/23.
//

import Foundation
import Alamofire


class ServiceHelper {
    
    static var instance : ServiceHelper{
        get{
            return ServiceHelper()
        }
    }
    
    func baseService(url: URL, request: [String:Any]?, method: HTTPMethod,_ completion: @escaping (Dictionary<String,Any>?)->()){
        
        
        var headers: HTTPHeaders = HTTPHeaders()
        
        headers = ["content_type":"application/json"]
        
        if let req = request?.jsonStringRepresentation {
            print("request for: \(url.absoluteString) at \(Date().yyyyMMddHHmmss())\n\n\nREQUEST:\(req))")
            
        }
       
        AF.request(url, method: method, parameters: request, encoding: JSONEncoding.default, headers: headers).response(){ response in
            
            if let status = response.response?.statusCode {
                switch(status){
                case 200:
                    let json = response.data?.json
                    if let data = json?["data"] as? Dictionary<String,Any> {
                        completion(data)
                    }else {
                        completion(["result":true])
                    }
                    print("success: \(Date().yyyyMMddHHmmss())\n\n\(String(describing: response.data?.json))")
                default:
                    completion(nil)
                    print("error with response status: \(status)")
                }
            }
            
            print(response)
            
        }
    }
    
    func driveService(url: String, request: [String:Any]? = nil , method: HTTPMethod = .get,_ completion: @escaping (Dictionary<String,Any>?)->()){
    
        if let jsonUrl = URL(string: url)
        {
            var headers: HTTPHeaders = HTTPHeaders()
            headers = ["content_type":"application/json"]
            
            AF.request(jsonUrl, method: method, parameters: request, encoding: JSONEncoding.default, headers: headers).response(){ response in
                
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        let json = response.data?.json
                        if let data = json {
                            completion(data)
                        } else {
                            completion(["result":true])
                        }
                        print("success: \(Date().yyyyMMddHHmmss())\n\n\(String(describing: response.data?.json))")
                        return
                    case 403:
                        completion(["error":403])
                        print("error with response status: \(status)")
                        return
                    default:
                        completion(nil)
                        print("error with response status: \(status)")
                    }
                } else {
                    completion(nil)
                }
                print(response)

            }
        } else {
            completion(nil)
        }
    }
    
    func driveServiceHtml(url: URL, request: [String:Any]?, method: HTTPMethod,_ completion: @escaping (String?)->()){
       
        AF.request(url, method: method, parameters: request, encoding: JSONEncoding.default, headers: nil).response(){ response in
            
            if let status = response.response?.statusCode {
                switch(status){
                case 200:
                    let json = response.data
                    if let data = json {
                        let text = String(data: data, encoding: String.Encoding.utf8)
                        completion(text)
                    }else {
                        completion(nil)
                    }
                    print("success: \(Date().yyyyMMddHHmmss())\n\n\(String(describing: response.data?.json))")
                default:
                    completion(nil)
                    print("error with response status: \(status)")
                }
            }
        }
    }
    
    func storedJsonService(nameFile: String, request: [String:Any]?, method: HTTPMethod,_ completion: @escaping (Dictionary<String,Any>?)->()){
      
        print("MOCK request for: \(nameFile) at \(Date().yyyyMMddHHmmss())\n")
        
        do {
            guard let fileURL = Bundle.main.path(forResource: "\(nameFile)", ofType: "json")
            else {
                completion(nil)
                return
            }
            let data = try Data(contentsOf: URL(fileURLWithPath: fileURL))
            if let dictionary = try JSONSerialization.jsonObject(with: data) as? Dictionary<String,Any>{
                completion(dictionary)
                return
            }
        } catch {
            completion(nil)
            return
        }
        completion(nil)
    }
    
    func sendFirebaseNofitication(secretKey: String?, entry: [String: Any], topic: String?){
        
        var headers: HTTPHeaders = HTTPHeaders()
        if let key = secretKey, let topic = topic {
            headers = ["content_type":"application/json", "Authorization":"key=\(key)"]
            
            let condition = "'\(topic)' in topics"
            
            let url = "https://fcm.googleapis.com/fcm/send"
            
            AF.request(URL(string: url)!, method: .post as HTTPMethod, parameters: ["notification": entry, "condition" : condition], encoding: JSONEncoding.default, headers: headers).response(){ response in
                
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        print("sended")
                    default:
                        print("error with response status: \(status)")
                    }
                }
                print(response)
            }
        }
    }
    
    func sendFirebaseNofitication(secretKey: String?, entry: [String: Any], token: String?){
        
        var headers: HTTPHeaders = HTTPHeaders()
        if let key = secretKey, let token = token {
            headers = ["content_type":"application/json", "Authorization":"key=\(key)"]
            let notification = ["notification": entry] as [String:Any]
            let url = "https://fcm.googleapis.com/fcm/send"
            
            AF.request(URL(string: url)!, method: .post as HTTPMethod, parameters: notification, encoding: JSONEncoding.default, headers: headers).response(){ response in
                
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        print("sended")
                    default:
                        print("error with response status: \(status)")
                    }
                }
                print(response)
            }
        }
    }
    
    
    func sendAppNofitication(entry: [String: Any]){
        
        
        let content = UNMutableNotificationContent()
        content.title = entry["title"] as? String ?? "Team Creato"
        content.body = entry["body"] as? String ?? "Hai appena creato il tuo team"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Errore nell'aggiunta della notifica: \(error.localizedDescription)")
            }
        }
    }
}
