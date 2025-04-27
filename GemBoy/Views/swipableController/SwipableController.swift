//
//  SwipableController.swift
//  Project
//
//  Created by EGONNEDGJ on 16/03/23.
//

import Foundation
import UIKit

class SwipableController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var holdView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var collectioView: UICollectionView?
    
    var delegate : SwipableControllerDelegate?
    var data : [String] = []

    let screenSize = UIScreen.main.bounds.size
    
    let fullView: CGFloat = 100 // remainder of screen height
    var partialView: CGFloat {
        return UIScreen.main.bounds.height - 270
    }
    
    var numberOfSection: CGFloat{
        return 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: numberOfSection * screenSize.width,
                                        height: scrollView.frame.size.height)
        collectioView = configureCollectionViews(position: 0, cellIdentifier: SwipableControllerCell.identifier, cell: SwipableControllerCell.self)
        collectioView?.isScrollEnabled = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
//        pageControl.numberOfPages =  Int(numberOfSection)
//        pageControl.isUserInteractionEnabled = false
        holdView.layer.cornerRadius = 3
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(SwipableController.panGesture))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
    }

    
    func configureCollectionViews(position: Int, cellIdentifier: String, cell: AnyClass) -> UICollectionView{
        let frameWidth = UIScreen.main.bounds.width * CGFloat(position)
        let frame = CGRect(x:  frameWidth,
                           y: 0,
                           width: UIScreen.main.bounds.width,
                           height: view.frame.height - 40)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        let width = (CGFloat) (screenSize.width-20) / 5.1
        layout.itemSize = CGSize(width: width, height: 90)
        
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        scrollView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            UINib(nibName: cellIdentifier, bundle: Bundle(for: cell)),
            forCellWithReuseIdentifier: cellIdentifier)
        
        return collectionView
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareBackgroundView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.6) { [weak self] in
            guard let `self` = self else { return }
            let frame = self.view.frame
            let yComponent = self.partialView
            self.view.frame = CGRect(x: 0,
                                     y: yComponent,
                                     width: frame.width,
                                     height: UIScreen.main.bounds.height - self.partialView)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectioView?.frame = CGRect(x: 0,
                                     y: 0,
                                     width: UIScreen.main.bounds.width,
                                     height: view.frame.height - 40)
        
        scrollView.contentSize = CGSize(width: numberOfSection * screenSize.width,
                                        height: scrollView.frame.size.height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Pan Gesture
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        
        let y = self.view.frame.minY
        if y + translation.y >= fullView {
            let newMinY = y + translation.y
            self.view.frame = CGRect(x: 0, y: newMinY, width: view.frame.width, height: UIScreen.main.bounds.height - newMinY )
            self.view.layoutIfNeeded()
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            duration = duration > 1.3 ? 1 : duration
            //velocity is direction of gesture
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    if y + translation.y >= self.partialView  {
                        self.removeBottomSheetView()
                    } else {
                        self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: UIScreen.main.bounds.height - self.partialView)
                        self.view.layoutIfNeeded()
                    }
                } else {
                    if y + translation.y >= self.partialView  {
                        self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: UIScreen.main.bounds.height - self.partialView)
                        self.view.layoutIfNeeded()
                    } else {
                        self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: UIScreen.main.bounds.height - self.fullView)
                        self.view.layoutIfNeeded()
                    }
                }
                
            }, completion: nil)
        }
    }
    
    func removeBottomSheetView() {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: UIView.AnimationOptions.curveEaseIn,
                       animations: { () -> Void in
                        var frame = self.view.frame
                        frame.origin.y = UIScreen.main.bounds.maxY
                        self.view.frame = frame
                        
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParent()
            self.delegate?.viewDidDisappear()
        })
    }
    
    func prepareBackgroundView(){
        let blurEffect = UIBlurEffect.init(style: .light)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        let bluredView = UIVisualEffectView.init(effect: blurEffect)
        bluredView.contentView.addSubview(visualEffect)
        visualEffect.frame = UIScreen.main.bounds
        bluredView.frame = UIScreen.main.bounds
        view.insertSubview(bluredView, at: 0)
    }
}

extension SwipableController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.bounds.width
        let pageFraction = scrollView.contentOffset.x / pageWidth
        
    }
}

// MARK: - UICollectionViewDataSource
extension SwipableController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: SwipableControllerCell.identifier, for: indexPath) as! SwipableControllerCell

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

protocol SwipableControllerDelegate {
    func didSelectView(view: UIView)
    func didSelectCampaing(campaign: String, index: Int)
    func viewDidDisappear()
}
