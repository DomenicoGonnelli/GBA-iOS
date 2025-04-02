//
//  System.swift
//  Delta
//
//  Created by Riley Testut on 4/30/17.
//  Copyright © 2017 Riley Testut. All rights reserved.
//

import DeltaCore

import SNESDeltaCore
import GBADeltaCore
import GBCDeltaCore
import NESDeltaCore
import N64DeltaCore
import MelonDSDeltaCore
import Systems



enum System: CaseIterable
{
    case nes
    case genesis
    case snes
    case n64
    case gbc
    case gba
    case ds
    
    static var DGITems: [System] {
        return [.nes,.snes,.n64, .gbc, .gba]
    }
    
    static var registeredSystems: [System] {
        let systems = System.allCases.filter { Delta.registeredCores.keys.contains($0.gameType) }
        return systems
    }
    
    static var allCores: [DeltaCoreProtocol] {
        return [NES.core, SNES.core, N64.core, GBC.core, GBA.core]
    }
}

extension System
{
    var localizableName: String {
        switch self
        {
        case .nes: return "Nintendo".localizable
        case .snes: return "Super Nintendo".localizable
        case .n64: return "Nintendo 64".localizable
        case .gbc: return "Game Boy Color".localizable
        case .gba: return "Game Boy Advance".localizable
        case .ds: return "Nintendo DS".localizable
        case .genesis: return "Sega Genesis".localizable
        }
    }
    
    var localizableShortName: String {
        switch self
        {
        case .nes: return "Nintendo_s".localizable
        case .snes: return "Super Nintendo_s".localizable
        case .n64: return "Nintendo 64_s".localizable
        case .gbc: return "Game Boy Color_s".localizable
        case .gba: return "Game Boy Advance_s".localizable
        case .ds: return "Nintendo DS_s".localizable
        case .genesis: return "Sega Genesis_s".localizable
        }
    }
    
    var year: Int {
        switch self
        {
        case .nes: return 1985
        case .genesis: return 1989
        case .snes: return 1990
        case .n64: return 1996
        case .gbc: return 1998
        case .gba: return 2001
        case .ds: return 2004
        }
    }
}

extension System
{
    var deltaCore: DeltaCoreProtocol {
        switch self
        {
        case .nes: return NES.core
        case .snes: return SNES.core
        case .n64: return N64.core
        case .gbc: return GBC.core
        case .gba: return GBA.core
        case .ds: return Settings.preferredCore(for: .ds) ?? MelonDS.core
        case .genesis: return GPGX.core
        }
    }
    
    var gameType: DeltaCore.GameType {
        switch self
        {
        case .nes: return .nes
        case .snes: return .snes
        case .n64: return .n64
        case .gbc: return .gbc
        case .gba: return .gba
        case .ds: return .ds
        case .genesis: return .genesis
        }
    }
    
    init?(gameType: DeltaCore.GameType)
    {
        switch gameType
        {
        case GameType.nes: self = .nes
        case GameType.snes: self = .snes
        case GameType.n64: self = .n64
        case GameType.gbc: self = .gbc
        case GameType.gba: self = .gba
        case GameType.ds: self = .ds
        case GameType.genesis: self = .genesis
        default: return nil
        }
    }
}

extension DeltaCore.GameType
{
    init?(fileExtension: String)
    {
        switch fileExtension.lowercased()
        {
        case "nes": self = .nes
        case "smc", "sfc", "fig": self = .snes
        case "n64", "z64": self = .n64
        case "gbc", "gb": self = .gbc
        case "gba": self = .gba
        case "ds", "nds": self = .ds
        case "gen", "bin", "md", "smd": self = .genesis
        default: return nil
        }
    }
}
