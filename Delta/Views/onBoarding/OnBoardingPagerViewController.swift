//
//  OnBoardingPagerViewController.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 12/01/23.
//

import Foundation
import UIKit

class OnBoardingPagerViewController : UIPageViewController, OnBoardingDelegate{
    
    var orderedViewControllers : [OnBoardingBaseViewController] =  []
    var controller : OnBoardingPagerDelegate?
    var currentItem : OnBoardingGenericItem?
    var currentIndex : Int?
    var pageControl : UIPageControl?
    
    var showedItem: OnBoardingGenericItem?{
        if let index = currentIndex, index < orderedViewControllers.count {
            return orderedViewControllers[index].onBoardingItem
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        pageControl?.numberOfPages = orderedViewControllers.count
        pageControl?.currentPage = 0
        
        pageControl?.currentPageIndicatorTintColor = UIColor.white
        pageControl?.pageIndicatorTintColor = UIColor.lightGray
        
        for controller in orderedViewControllers {
            controller.onBoardingItem?.delegate = self
        }
        
        if let firstViewController = orderedViewControllers.first {
            firstViewController.loadViewIfNeeded()
            setViewControllers([firstViewController],direction: .forward, animated: true){ [weak self] _ in
                self?.setOnBoardingItem(item: firstViewController.onBoardingItem)
            }
        }
    }
    
    func setOnBoardingItem(item: OnBoardingGenericItem?){
        self.currentItem = item
        self.controller?.setOnBoardingItem(item)
    }
    
    func moveToNextPage() {
        guard let currentViewController = self.viewControllers?.first else { return print("Failed to get current view controller") }
        guard let nextViewController = self.dataSource?.pageViewController( self, viewControllerAfter: currentViewController) else { return }
        setViewControllers([nextViewController], direction: .forward, animated: false){_ in
            self.delegate?.pageViewController?(self, willTransitionTo: [nextViewController])
            self.delegate?.pageViewController?(self, didFinishAnimating: true, previousViewControllers: [currentViewController], transitionCompleted: true)
        }
        
    }
    
    func onLinkClicked(with key: String?) {
        
    }
    
    func enableButton(_ enable: Bool) {
        controller?.enableButton(enable)
    }
}

extension OnBoardingPagerViewController : UIPageViewControllerDataSource{
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewController = viewController as? OnBoardingBaseViewController, let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard orderedViewControllers.count > previousIndex, previousIndex >= 0 else {
            return nil
        }
        currentItem = orderedViewControllers[previousIndex].onBoardingItem
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewController = viewController as? OnBoardingBaseViewController, let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        currentItem = orderedViewControllers[nextIndex].onBoardingItem
        return orderedViewControllers[nextIndex]
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }

    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first as? OnBoardingBaseViewController,
              let firstViewControllerIndex = orderedViewControllers.firstIndex(of: firstViewController) else {
                return 0
        }
        return firstViewControllerIndex
    }
    
}


extension OnBoardingPagerViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        controller?.hideButtons(false)
        if completed, let currentIndex = currentIndex {
            setOnBoardingItem(item: currentItem)
            pageControl?.currentPage = currentIndex
        } else if let vc = previousViewControllers.first as? OnBoardingBaseViewController{
            currentIndex = orderedViewControllers.firstIndex(of: vc)
            currentItem = vc.onBoardingItem
            setOnBoardingItem(item: currentItem)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let vc = pendingViewControllers.first as? OnBoardingBaseViewController{
            currentItem = vc.onBoardingItem
            currentIndex = orderedViewControllers.firstIndex(of: vc)
        }
    }
}


protocol OnBoardingPagerDelegate {
    func hideButtons(_ hide: Bool)
    func setOnBoardingItem(_ item: OnBoardingGenericItem?)
    func getUrl(for key: String?) -> URL?
    func enableButton(_ enable: Bool)
}
