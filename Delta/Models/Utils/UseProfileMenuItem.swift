//
//  UseProfileMenuItem.swift
//  Project
//
//  Created by Domenico Gonnelli on 25/02/25.
//

import Foundation
import UIKit


public enum UserProfileMenuItem {
    case loginMethod, biometricLoginTI,biometricLoginFI, teamDetail, changeLanguage, changePaletteColor, instagramPage, contactUs, push, deleteTeam, deleteAccount, logout, empty, shareApp
    
    
    static var sections: [String : [UserProfileMenuItem]] {
        
        var loginMode :[UserProfileMenuItem] = [.loginMethod]
        let bio = LocalAuthenticationManagar.shared.getBiometricType()
        
        if bio == .touchID {
            loginMode.append(.biometricLoginTI)
        } else if bio == .faceID {
            loginMode.append(.biometricLoginFI)
        }
        
        return [
            "loginMode": loginMode,
            "configuration":[.changeLanguage, .changePaletteColor],
            "contactUS":[.instagramPage, .contactUs],
            "userInfo" : [.push, .teamDetail, .shareApp],
            "clear":[.deleteTeam,.deleteAccount,.logout]
        ]
    }
    
    static var sectionNames: [String] {
        return ["loginMode","configuration","contactUS","userInfo","clear"]
    }
    
    var title: String{
        if self == .loginMethod {
            return String(format: "\(self)UserProfileTitle".localizable, LoginManager.shared.user?.loginMode.rawValue ?? "")
        }
        return "\(self)UserProfileTitle".localizable
    }
    
    var icon: UIImage?{
        return UIImage(named: "\(self)UserProfile")
    }
    
    
    static var biometricImageName: String{
        let bio = LocalAuthenticationManagar.shared.getBiometricType()
        if bio == .touchID {
            return "\(UserProfileMenuItem.biometricLoginTI)UserProfile"
        } else if bio == .faceID {
            return "\(UserProfileMenuItem.biometricLoginFI)UserProfile"
        }
        return ""
    }
    
    static var biometricName: String{
        let bio = LocalAuthenticationManagar.shared.getBiometricType()
        if bio == .touchID {
            return "Touch-ID"
        } else if bio == .faceID {
            return "Face-ID"
        }
        return ""
    }
    
    var iconBGColor: UIColor?{
        switch self {
        case .loginMethod:
            return .primaryColorFix
        default:
            return .clear
        }
    }
    
    var otherImage: UIImage?{
        switch self {
        case .loginMethod:
            if let loginMode = LoginManager.shared.user?.loginMode {
                
                switch loginMode {
                    
                case .apple:
                    return UIImage(named: "apple")
                case .facebook, .phone, .null:
                    return nil
                case .google:
                    return UIImage(named: "google")
                case .twitter:
                    return UIImage(named: "TwitterLogin")
                }
            }
            return nil
        default:
            return nil
        }
    }
    
    var showArrow: Bool{
        return self == .biometricLoginTI ||
        self == .biometricLoginFI ||
        self == .changeLanguage ||
        self == .changePaletteColor ||
        self == .instagramPage ||
        self == .contactUs ||
        self == .deleteTeam ||
        self == .deleteAccount ||
        self == .logout ||
        self == .push ||
        self == .teamDetail ||
        self == .shareApp
    }
    
}
