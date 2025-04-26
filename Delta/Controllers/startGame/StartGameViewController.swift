//
//  StartGameViewController.swift
//  Delta
//
//  Created by Domenico Gonnelli on 23/04/25.
//

import UIKit
import Foundation
import SwiftUI
import MobileCoreServices
import AVFoundation
import RegexBuilder
import DeltaCore
import MelonDSDeltaCore
import Roxas
import SDWebImage

class StartGameViewController: TabBarItemViewController {
    
    static let identifier = "StartGameViewController"
   
    @IBOutlet weak var tableView: UITableView!

    var data: [ChartModel] = []
    
    internal var dataSource: RSTFetchedResultsTableViewPrefetchingDataSource<Game, UIImage>?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        updateDataSource()

    }
    
    
    func updateDataSource()
    {
        let context = DatabaseManager.shared.viewContext
        let fetchRequest: NSFetchRequest<Game> = Game.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Game.name), ascending: true)]
        fetchRequest.returnsObjectsAsFaults = false

        do {
            let games = try context.fetch(fetchRequest)
            print(games)
            // use 'games' come preferisci
        } catch {
            print("Errore nel fetch: \(error)")
        }
        tableView.reloadData()
    }
    
    @IBAction func goToGame(_ sender: Any){
        controller?.goToLunch()
    }
    
   
    
    static func instance() -> StartGameViewController{
        let vc = UIStoryboard(name: "StartGame", bundle: nil).instantiateViewController(withIdentifier: identifier) as! StartGameViewController
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
    
    static func push(prensenter: UIViewController?, image: UIImage?) {
        let vc = instance()
        prensenter?.navigationController?.pushViewController(vc, animated: true)
    }
}


extension StartGameViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.itemCount ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StartGameCell.indetifier, for: indexPath) as! StartGameCell
        cell.configureView(title: "no game yet. press GO GAME", img: nil)
        if let name = dataSource?.item(at: indexPath).name, let img = dataSource?.item(at: indexPath).artworkURL, let data = try? Data(contentsOf: img) {
            if let count = dataSource?.itemCount, count > 0 {
                cell.configureView(title: name, img: UIImage(data: data))
            } else {
                cell.configureView(title: "no game yet. press GO GAME", img: nil)
            }
        }
        return cell
    }
    
}

