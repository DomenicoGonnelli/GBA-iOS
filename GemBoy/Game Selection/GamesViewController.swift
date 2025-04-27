//
//  GamesViewController.swift
//  Delta
//
//  Created by Riley Testut on 10/12/15.
//  Copyright © 2015 Riley Testut. All rights reserved.
//

import UIKit
import CoreData
import MobileCoreServices
import DeltaCore
import Roxas

class GamesViewController: BaseViewController
{
    
    static let identifier = "GamesViewController"
    
    var theme: Theme = .opaque {
        didSet {
            self.updateTheme()
        }
    }
    
    var activeEmulatorCore: EmulatorCore? {
        didSet
        {
            let game = oldValue?.game as? Game
            NotificationCenter.default.removeObserver(self, name: .NSManagedObjectContextObjectsDidChange, object: game?.managedObjectContext)
            
            if let game = self.activeEmulatorCore?.game as? Game
            {
                NotificationCenter.default.addObserver(self, selector: #selector(GamesViewController.managedObjectContextDidChange(with:)), name: .NSManagedObjectContextObjectsDidChange, object: game.managedObjectContext)
            }
            
            if #available(iOS 16, *)
            {
                self.resumeButton?.isHidden = (self.activeEmulatorCore?.game == nil)
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private var pageViewController: UIPageViewController!
    private var placeholderView: RSTPlaceholderView!
    private var pageControl: UIPageControl!
    
    var presenter: UIViewController?
    
    private let fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>
    
    private var searchController: RSTSearchController?
    private lazy var importController: ImportController = self.makeImportController()
    
    private var syncingToastView: RSTToastView? {
        didSet {
            if self.syncingToastView == nil
            {
                self.syncingProgressObservation = nil
            }
        }
    }
    private var syncingProgressObservation: NSKeyValueObservation?
    
    private var resumeButton: UIBarButtonItem?
    @IBOutlet private var importButton: UIBarButtonItem!
    
    @IBOutlet private var stack: UIStackView!
    @IBOutlet private var stackWidth: NSLayoutConstraint!

    @IBOutlet private var selectedRoundedView: UIView!
    
    private var orderedSystem : [System] = [.gba, .gbc, .nes, .snes, .n64]
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("initWithNibName: not implemented")
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        let fetchRequest = GameCollection.rst_fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(GameCollection.index), ascending: true)]
                
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DatabaseManager.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init(coder: aDecoder)
        
        self.fetchedResultsController.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(GamesViewController.settingsDidChange(_:)), name: Settings.didChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GamesViewController.emulationDidQuit(_:)), name: EmulatorCore.emulationDidQuitNotification, object: nil)
    }
}

//MARK: - UIViewController -
/// UIViewController
extension GamesViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
                
        self.placeholderView = RSTPlaceholderView(frame: self.view.bounds)
        self.placeholderView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.placeholderView.textLabel.text = "No_Games".localizable
        self.placeholderView.detailTextLabel.text = "import_games_label".localizable
      
        self.placeholderView.stackView.setCustomSpacing(20.0, after: self.placeholderView.detailTextLabel)
        self.view.insertSubview(self.placeholderView, at: 0)
        
        self.pageControl = UIPageControl()
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.pageControl.hidesForSinglePage = false
        self.pageControl.numberOfPages = 3
        self.pageControl.currentPageIndicatorTintColor = UIColor.deltaPurple
        self.pageControl.pageIndicatorTintColor = UIColor.lightGray
        self.navigationController?.toolbar.addSubview(self.pageControl)
        
        self.pageControl.centerXAnchor.constraint(equalTo: (self.navigationController?.toolbar.centerXAnchor)!, constant: 0).isActive = true
        self.pageControl.centerYAnchor.constraint(equalTo: (self.navigationController?.toolbar.centerYAnchor)!, constant: 0).isActive = true
        
        if #available(iOS 16, *)
        {
            let resumeButton = UIBarButtonItem(title: "Resume".localizable, style: .done, target: self, action: #selector(GamesViewController.resumeGame))
            resumeButton.isHidden = true
            self.resumeButton = resumeButton
            
            self.setToolbarItems([.flexibleSpace(), resumeButton], animated: false)
        }
        
        if let navigationController = self.navigationController
        {
            if #available(iOS 13.0, *)
            {
                navigationController.overrideUserInterfaceStyle = .dark
                
                let navigationBarAppearance = navigationController.navigationBar.standardAppearance.copy()
                navigationBarAppearance.backgroundEffect = UIBlurEffect(style: .dark)
                navigationController.navigationBar.standardAppearance = navigationBarAppearance
                navigationController.navigationBar.scrollEdgeAppearance = navigationBarAppearance
                
                let toolbarAppearance = navigationController.toolbar.standardAppearance.copy()
                toolbarAppearance.backgroundEffect = UIBlurEffect(style: .dark)
                navigationController.toolbar.standardAppearance = toolbarAppearance
                
                if #available(iOS 15, *)
                {
                    navigationController.toolbar.scrollEdgeAppearance = toolbarAppearance
                }
            }
            else
            {
                navigationController.navigationBar.barStyle = .blackTranslucent
                navigationController.toolbar.barStyle = .blackTranslucent
            }            
        }
        
        if #available(iOS 14, *)
        {
            self.importController.presentingViewController = self
            
            let importActions = self.importController.makeActions().menuActions
            let importMenu = UIMenu(title:  "import".localizable, image: UIImage(systemName: "square.and.arrow.down"), children: importActions)
            self.importButton.menu = importMenu

            self.importButton.action = nil
            self.importButton.target = nil
        }
        else
        {
            self.importController.barButtonItem = self.importButton
        }
        
        self.navigationItem.leftBarButtonItem?.accessibilityLabel = "Menu".localizable
        
        self.prepareSearchController()
        
        self.updateTheme()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if self.fetchedResultsController.performFetchIfNeeded()
        {
            self.updateSections(animated: false)
        }
        
        if let activeEmulatorCore, !activeEmulatorCore.isWirelessMultiplayerActive
        {
            DispatchQueue.global().async {
                activeEmulatorCore.stop()
            }
        }
    }
    
    @IBAction func goToSetting(_ sender: Any){
        print(presenter)
        UserProfileViewController.push2(prensenter: self, backcontroller: presenter)
        //SettingsViewController.push(from: self)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
    
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Segues -
/// Segues
extension GamesViewController
{
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        guard let identifier = segue.identifier else { return }
        
        switch identifier
        {
        case "embedPageViewController":
            self.pageViewController = segue.destination as? UIPageViewController
            self.pageViewController.dataSource = self
            self.pageViewController.delegate = self
            self.pageViewController.view.isHidden = true
        
        case "showSettings":
            let destinationViewController = segue.destination
            destinationViewController.presentationController?.delegate = self
            
        default: break
        }
    }
    
    @IBAction private func unwindFromSettingsViewController(_ segue: UIStoryboardSegue)
    {
//        self.sync()
    }
}

// MARK: - UI -
/// UI
extension GamesViewController
{
    func prepareSearchController()
    {
        let searchResultsController = self.storyboard?.instantiateViewController(withIdentifier: "gameCollectionViewController") as! GameCollectionViewController
        searchResultsController.gameCollection = nil
        searchResultsController.theme = self.theme
        searchResultsController.activeEmulatorCore = self.activeEmulatorCore
        
        let placeholderView = RSTPlaceholderView()
        placeholderView.textLabel.localizedKey = "No_Games_Found"
        placeholderView.detailTextLabel.localizedKey = "No_Games_Found_text"
        
        switch self.theme
        {
        case .opaque: searchResultsController.dataSource.placeholderView = placeholderView
        case .translucent:
            let vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: UIBlurEffect(style: .dark)))
            vibrancyView.contentView.addSubview(placeholderView, pinningEdgesWith: .zero)
            searchResultsController.dataSource.placeholderView = vibrancyView
        }
        
        self.searchController = RSTSearchController(searchResultsController: searchResultsController)
        self.searchController?.searchableKeyPaths = [#keyPath(Game.name)]
        self.searchController?.searchHandler = { [weak self, weak searchResultsController] (searchValue, _) in
            guard let self = self else { return nil }
            
            if self.searchController?.searchBar.text?.isEmpty == false
            {
                self.pageViewController.view.isHidden = true
            }
            else
            {
                self.pageViewController.view.isHidden = false
            }
            
            searchResultsController?.dataSource.predicate = searchValue.predicate
            return nil
        }
        self.searchController?.searchBar.barStyle = .black
        
        self.navigationItem.searchController = self.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        self.definesPresentationContext = true
    }
    
    func updateTheme()
    {
        switch self.theme
        {
        case .opaque: self.view.backgroundColor = .clear
        case .translucent: self.view.backgroundColor = nil
        }
                
        if let viewControllers = self.pageViewController.viewControllers as? [GameCollectionViewController]
        {
            for collectionViewController in viewControllers
            {
                collectionViewController.theme = self.theme

            }
        }
    }
}

// MARK: - Helper Methods -
private extension GamesViewController
{
    func viewControllerForIndex(_ index: Int) -> GameCollectionViewController?
    {
        guard let pages = self.fetchedResultsController.sections?.first?.numberOfObjects, pages > 0 else { return nil }
        
        // Return nil if only one section, and not asking for the 0th view controller
        guard !(pages == 1 && index != 0) else { return nil }
        
        var safeIndex = index % pages
        if safeIndex < 0
        {
            safeIndex = pages + safeIndex
        }
        
        let indexPath = IndexPath(row: safeIndex, section: 0)
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "gameCollectionViewController") as! GameCollectionViewController
        viewController.gameCollection = self.fetchedResultsController.object(at: indexPath) as? GameCollection
        viewController.theme = self.theme
        viewController.activeEmulatorCore = self.activeEmulatorCore
        
        return viewController
    }
    
    func updateSections(animated: Bool, force: Bool = false)
    {
        let sections = self.fetchedResultsController.sections?.first?.numberOfObjects ?? 0
        self.pageControl.numberOfPages = sections
        
        var resetPageViewController = false
        
        if let viewController = self.pageViewController.viewControllers?.first as? GameCollectionViewController, let gameCollection = viewController.gameCollection
        {
            if let index = self.fetchedResultsController.fetchedObjects?.firstIndex(where: { $0 as! GameCollection == gameCollection })
            {
                self.pageControl.currentPage = index
            }
            else
            {
                resetPageViewController = true
                
                self.pageControl.currentPage = 0
            }
            
        }
        
        if self.pageViewController.viewControllers?.count == 0
        {
            resetPageViewController = true
        }
        
        self.navigationController?.setToolbarHidden(true, animated: animated)
        
        if sections > 0
        {
            // Reset page view controller if currently hidden or current child should view controller no longer exists
            
            setStackView()
            
            if self.pageViewController.view.isHidden || resetPageViewController || force
            {
                var index = 0
                
                if let gameCollection = Settings.previousGameCollection
                {
                    if let gameCollectionIndex = self.fetchedResultsController.fetchedObjects?.firstIndex(where: { $0 as! GameCollection == gameCollection })
                    {
                        index = gameCollectionIndex
                        
                    }
                }
                
                if let viewController = self.viewControllerForIndex(index)
                {
                    self.pageViewController.view.setHidden(false, animated: animated)
                    self.pageViewController.view.superview?.setHidden(false, animated: animated)
                    self.placeholderView.setHidden(true, animated: animated)
                    
                    self.pageViewController.setViewControllers([viewController], direction: .forward, animated: false, completion: nil)
                    
                    self.title = viewController.title
                    self.pageControl.currentPage = index
                    
                    if let gameCollection = viewController.gameCollection{
                        setBottomView(gameCollection: gameCollection)
                    }
                }
            }
            else
            {
                self.pageViewController.setViewControllers(self.pageViewController.viewControllers, direction: .forward, animated: false, completion: nil)
            }
        }
        else
        {
            self.title = "Games".localizable

            self.pageViewController.view.setHidden(true, animated: animated)
            self.pageViewController.view.superview?.setHidden(true, animated: animated)
            self.placeholderView.setHidden(false, animated: animated)
        }
    }
    
    func setStackView(){
        
        for view in stack.arrangedSubviews {
            stack.removeArrangedSubview(view)
            view.removeFromSuperview() // 🔥 importante!
        }
        if let game = self.fetchedResultsController.fetchedObjects {
            stackWidth.constant = CGFloat(70 * game.count)
            for i in 0..<game.count {
                if let g = game[i] as? GameCollection {
                    let sys = SystemSelection(frame: CGRect (x: 70*i, y: 0, width: 70, height: 70))
                    sys.setSystem(system: g.system, delegate: self)
                    stack.addArrangedSubview(sys)
                }
                
            }
            stack.layoutIfNeeded()
        }
    }
    
    @objc func openFAQ()
    {
        let faqURL = URL(string: "https://faq.deltaemulator.com/getting-started/importing-games")!
        UIApplication.shared.open(faqURL)
    }
    
    @objc func resumeGame()
    {
        guard
            let gameCollectionViewController = self.pageViewController.viewControllers?.first as? GameCollectionViewController,
            let activeEmulatorCore = gameCollectionViewController.activeEmulatorCore,
            let game = activeEmulatorCore.game as? Game
        else { return }
        
        gameCollectionViewController.resume(game)
    }
}

//MARK: - Importing -
/// Importing
extension GamesViewController: ImportControllerDelegate
{
    private func makeImportController() -> ImportController
    {
        var documentTypes = Set(System.registeredSystems.map { $0.gameType.rawValue })
        documentTypes.insert(kUTTypeZipArchive as String)
        documentTypes.insert("com.rileytestut.delta.skin")
        
        #if BETA
        // .bin files (Genesis ROMs)
        documentTypes.insert("com.apple.macbinary-archive")
        #endif
        
        // Add GBA4iOS's exported UTIs in case user has GBA4iOS installed (which may override Delta's UTI declarations)
        documentTypes.insert("com.rileytestut.gba")
        documentTypes.insert("com.rileytestut.gbc")
        documentTypes.insert("com.rileytestut.gb")
        
        let itunesImportOption = iTunesImportOption(presentingViewController: self)
        
        let importController = ImportController(documentTypes: documentTypes)
        importController.delegate = self
        importController.importOptions = [itunesImportOption]
        
        return importController
    }
    
    @IBAction private func importFiles()
    {
        self.present(self.importController, animated: true, completion: nil)
    }
    
    func importController(_ importController: ImportController, didImportItemsAt urls: Set<URL>, errors: [Error])
    {
        for error in errors
        {
            print(error)
        }
        
        let gameURLs = urls.filter { $0.pathExtension.lowercased() != "deltaskin" }
        DatabaseManager.shared.importGames(at: Set(gameURLs)) { (games, errors) in
            if errors.count > 0
            {
                let alertController = UIAlertController.alertController(for: .games, with: errors)
                self.present(alertController, animated: true, completion: nil)
            }
            
            if games.count > 0
            {
                print("Imported Games:", games.map { $0.name })
            }
        }
        
        let controllerSkinURLs = urls.filter { $0.pathExtension.lowercased() == "deltaskin" }
        DatabaseManager.shared.importControllerSkins(at: Set(controllerSkinURLs)) { (controllerSkins, errors) in
            if errors.count > 0
            {
                let alertController = UIAlertController.alertController(for: .controllerSkins, with: errors)
                self.present(alertController, animated: true, completion: nil)
            }
            
            if controllerSkins.count > 0
            {
                print("Imported Controller Skins:", controllerSkins.map { $0.name })
            }
        }
    }
}

//MARK: - Syncing -
/// Syncing
private extension GamesViewController
{
    
    func quitEmulation()
    {
        DispatchQueue.main.async {
            self.activeEmulatorCore = nil
            
            if let viewControllers = self.pageViewController.viewControllers as? [GameCollectionViewController]
            {
                for collectionViewController in viewControllers
                {
                    collectionViewController.activeEmulatorCore = nil
                }
            }
            
            self.theme = .opaque
        }
    }
}

//MARK: - Notifications -
/// Notifications
private extension GamesViewController
{
    @objc func managedObjectContextDidChange(with notification: Notification)
    {
        guard let deletedObjects = notification.userInfo?[NSDeletedObjectsKey] as? Set<NSManagedObject> else { return }
        
        if let game = self.activeEmulatorCore?.game as? Game
        {
            if deletedObjects.contains(game)
            {                
                self.quitEmulation()
            }
        }
        else
        {
            self.quitEmulation()
        }
    }
    
    @objc func syncingDidStart(_ notification: Notification)
    {
        DispatchQueue.main.async {
//            self.showSyncingToastViewIfNeeded()
        }
    }
    
    @objc func syncingDidFinish(_ notification: Notification)
    {        
//        DispatchQueue.main.async {
//            guard let result = notification.userInfo?[SyncCoordinator.syncResultKey] as? SyncResult else { return }
////            self.showSyncFinishedToastView(result: result)
//        }
    }
    
    @objc func emulationDidQuit(_ notification: Notification)
    {
        guard let emulatorCore = notification.object as? EmulatorCore, emulatorCore == self.activeEmulatorCore else { return }
        self.quitEmulation()
    }
    
    @objc func settingsDidChange(_ notification: Notification)
    {
        guard let emulatorCore = self.activeEmulatorCore else { return }
        guard let game = emulatorCore.game as? Game else { return }
        
        game.managedObjectContext?.performAndWait {
            guard
                let name = notification.userInfo?[Settings.NotificationUserInfoKey.name] as? String, name == Settings.preferredCoreSettingsKey(for: emulatorCore.game.type),
                let core = notification.userInfo?[Settings.NotificationUserInfoKey.core] as? DeltaCoreProtocol, core != emulatorCore.deltaCore
            else { return }
            
            emulatorCore.stop()
            self.quitEmulation()
        }
    }
}

extension GamesViewController: SystemSelectionDelegate{
    
    func setSystem(system: System?){
        if let gameCollection = self.fetchedResultsController.fetchedObjects?.first(where: { ($0 as? GameCollection)?.system == system }) as? GameCollection {
            Settings.previousGameCollection = gameCollection
            updateSections(animated: true, force: true)
        }
        
    }
}

//MARK: - UIPageViewController -
/// UIPageViewController
extension GamesViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate
{
    
    
    //MARK: - UIPageViewControllerDataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        let viewController = self.viewControllerForIndex(self.pageControl.currentPage - 1)
        return viewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        let viewController = self.viewControllerForIndex(self.pageControl.currentPage + 1)
        return viewController
    }
    
    func setBottomView(gameCollection: GameCollection){
        
        if let index = self.fetchedResultsController.fetchedObjects?.firstIndex(where: { $0 as? GameCollection == gameCollection }) {
            stack.arrangedSubviews.forEach({
                if let view = $0 as? SystemSelection {
                    view.selectSystem(color: .lightGray.withAlphaComponent(0.5))
                }
            })
            
            self.stack.layoutIfNeeded()
            DispatchQueue.main.async {
                let center = self.stack.arrangedSubviews[index].center
                self.selectedRoundedView.center = center
                self.selectedRoundedView.alpha = 0
                self.selectedRoundedView.layoutIfNeeded()
                UIView.animate(withDuration: 0.2, animations: {
                    self.selectedRoundedView.alpha = 0.3
                    if let v = self.stack.arrangedSubviews[index] as? SystemSelection {
                        v.selectSystem(color: .white)
                    }
                })
            }
        }
    }
    
    
    //MARK: - UIPageViewControllerDelegate
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
        if let viewController = pageViewController.viewControllers?.first as? GameCollectionViewController, let gameCollection = viewController.gameCollection
        {
            let index = self.fetchedResultsController.fetchedObjects?.firstIndex(where: { $0 as! GameCollection == gameCollection }) ?? 0
            self.pageControl.currentPage = index
            
            Settings.previousGameCollection = gameCollection
            
            setBottomView(gameCollection: gameCollection)
        }
        else
        {
            Settings.previousGameCollection = nil
        }
        
        self.title = pageViewController.viewControllers?.first?.title
        
    }
}

extension GamesViewController: UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController)
    {
        if searchController.searchBar.text?.isEmpty == false
        {            
            self.pageViewController.view.isHidden = true
        }
        else
        {
            self.pageViewController.view.isHidden = false
        }
    }
}

//MARK: - NSFetchedResultsControllerDelegate -
/// NSFetchedResultsControllerDelegate
extension GamesViewController: NSFetchedResultsControllerDelegate
{
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        self.updateSections(animated: true)
    }
}

extension GamesViewController: UIAdaptivePresentationControllerDelegate
{
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController)
    {
//        self.sync()
    }
    
    
    static func instance() -> GamesViewController{
        var vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier) as! GamesViewController
        //vc.modalPresentationStyle = .fullScreen
        return vc
    }
    
       

    static func push(from controller: GameViewController?, theme: Theme, emulator: EmulatorCore?){
        
        let gamesViewController = instance()
        gamesViewController.theme = theme
        gamesViewController.activeEmulatorCore = emulator
        
        controller?.navigationController?.pushViewController(gamesViewController, animated: false)
    }
    
  
}
