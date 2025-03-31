//
//  LoginService.swift
//  Project
//
//  Created by EGONNEDGJ on 16/02/23.
//

import Foundation
import FirebaseAuth
import GoogleSignIn

class LoginService {
    
    static func doLogin(idToken: String, accessToken: String, _ completion: @escaping (UserModel?)->Void){
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                       accessToken: accessToken)
        login(loginMode: .google, credential: credential){ result in
            completion(result)
        }
        
    }
    
    private static func login(loginMode: LoginMode , credential: AuthCredential, _ completion: @escaping (UserModel?)->Void){
        
        Auth.auth().signIn(with: credential) { authResult, error  in
            if let _ = error {
               // print(error)
                completion(nil)
                return
            }
            
            FirestoreHelper.getUserData(){ user in
                if let user = user {
                    completion(user)
                } else {
                    let newUser = UserModel()
                    newUser.loginMode = loginMode
                    newUser.identificator = authResult?.user.email
                    newUser.name = authResult?.user.displayName
                    newUser.registrationDate = Date()
                    FirestoreHelper.updateUser(user: newUser)
                    completion(newUser)
                }
            }
            
        }
    }
    
    static func doAppleLogin(idToken: String, nonce: String, _ completion: @escaping (UserModel?)->Void){
        let credential = OAuthProvider.credential(providerID: .apple, idToken: idToken, rawNonce: nonce)
        login(loginMode: .apple, credential: credential){ result in
            completion(result)
        }
    }
}
