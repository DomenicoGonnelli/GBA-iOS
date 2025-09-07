//
//  DownloadRomOption.swift
//  GemBoy
//
//  Created by Domenico Gonnelli on 29/07/25.
//


import UIKit
import GameCore

struct DownloadRomOption: ImportOption
{
    let title = "dowload_new_roms".localizable
    let image: UIImage? = UIImage(named: "download_roms")
    
    private let presentingViewController: UIViewController
    
    init(presentingViewController: UIViewController)
    {
        self.presentingViewController = presentingViewController
    }
    
    func `import`(withCompletionHandler completionHandler: @escaping (Set<URL>?) -> Void)
    {
        GameDownloadViewController.push(prensenter: presentingViewController)
    }
}
