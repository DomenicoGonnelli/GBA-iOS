//
//  PremiumSubscriptionPagerViewController.swift
//  Project
//
//  Created by Domenico Gonnelli on 21/01/25.
//

import Foundation
import UIKit

class PremiumSubscriptionPagerViewController : UIPageViewController{
    
    var orderedViewControllers : [PremiumSinglePageViewController] =  []
    var controller : OnPremiumPagerDelegate?
    var currentItem : PremiumSubscriptionModel?
    var currentIndex : Int?
    var pageControl : UIPageControl?
    
    var showedItem: PremiumSubscriptionModel?{
        if let index = currentIndex, index < orderedViewControllers.count {
            return orderedViewControllers[index].item
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func startView(){
        dataSource = self
        delegate = self
        
        pageControl?.numberOfPages = orderedViewControllers.count
        pageControl?.currentPage = 0
        currentIndex = 0
        pageControl?.currentPageIndicatorTintColor = UIColor.secondaryColor
        pageControl?.pageIndicatorTintColor = UIColor.lightGray
        
        if let firstViewController = orderedViewControllers.first {
            firstViewController.loadViewIfNeeded()
            setViewControllers([firstViewController], direction: .forward, animated: true){ [weak self] _ in
                //self?.setOnBoardingItem(item: firstViewController.onBoardingItem)
            }
        }
    }
    
    func updateView(isNew: Bool){
        if let current = currentIndex{
            orderedViewControllers[current].refreshView(isNew: isNew)
        }
    }
    
    func moveToNextPage() {
        guard let currentViewController = self.viewControllers?.first else { return print("Failed to get current view controller") }
        guard let nextViewController = self.dataSource?.pageViewController( self, viewControllerAfter: currentViewController) else { return }
        setViewControllers([nextViewController], direction: .forward, animated: false){_ in
            self.delegate?.pageViewController?(self, willTransitionTo: [nextViewController])
            self.delegate?.pageViewController?(self, didFinishAnimating: true, previousViewControllers: [currentViewController], transitionCompleted: true)
        }
        
    }
    
    func moveToSpecificPage(nextViewController: UIViewController) {
        guard let currentViewController = self.viewControllers?.first else { return print("Failed to get current view controller") }
        setViewControllers([nextViewController], direction: .forward, animated: true){_ in
            self.delegate?.pageViewController?(self, willTransitionTo: [nextViewController])
            self.delegate?.pageViewController?(self, didFinishAnimating: true, previousViewControllers: [currentViewController], transitionCompleted: true)
        }
        
    }
    
}

extension PremiumSubscriptionPagerViewController : UIPageViewControllerDataSource{
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewController = viewController as? PremiumSinglePageViewController, let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard orderedViewControllers.count > previousIndex, previousIndex >= 0 else {
            return nil
        }
        currentItem = orderedViewControllers[previousIndex].item
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewController = viewController as? PremiumSinglePageViewController, let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        currentItem = orderedViewControllers[nextIndex].item
        return orderedViewControllers[nextIndex]
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }

    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first as? PremiumSinglePageViewController,
              let firstViewControllerIndex = orderedViewControllers.firstIndex(of: firstViewController) else {
                return 0
        }
        return firstViewControllerIndex
    }
    
}


extension PremiumSubscriptionPagerViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        if completed, let currentIndex = currentIndex {
            pageControl?.currentPage = currentIndex
        } else if let vc = previousViewControllers.first as? PremiumSinglePageViewController{
            currentIndex = orderedViewControllers.firstIndex(of: vc)
            currentItem = vc.item
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let vc = pendingViewControllers.first as? PremiumSinglePageViewController{
            currentItem = vc.item
            currentIndex = orderedViewControllers.firstIndex(of: vc)
        }
    }
}




protocol OnPremiumPagerDelegate {
    func subscribe_premium(selectedSubscription: PremiumSubscriptionModel?)
}
