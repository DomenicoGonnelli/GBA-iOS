//
//  LinkEnum.swift
//  GemBoy
//
//  Created by Domenico Gonnelli on 08/05/25.
//

public enum ConnectionLinkState: String {
    case Link_Ok, Link_error, Link_needs_update, Link_abort
    
    static func state(forIndex value: Int) -> ConnectionLinkState {
        switch value {
        case 0:
            return .Link_Ok
        case 1:
            return .Link_error
        case 2:
            return .Link_needs_update
        case 3:
            return .Link_abort
        default:
            return .Link_error
        }
    }
    
    var textValue : String {
        switch self {
        case .Link_Ok:
            return "link_OK_text".localizable
        case .Link_error:
            return "link_Error_text".localizable
        case .Link_needs_update:
            return "link_Update_text".localizable
        case .Link_abort:
            return "link_Abort_text".localizable
        }
    }
    
    
}
