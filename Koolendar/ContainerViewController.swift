//
//  ContainerViewController.swift
//  Koolendar
//
//  Created by Addison Bean on 8/18/15.
//  Copyright (c) 2015 INOVA. All rights reserved.
//

import UIKit

enum SlideOutState {
    case BothCollapsed, LeftPanelExpanded
}

class ContainerViewController: UIViewController, CenterViewControllerDelegate {
    
    var centerNavigationController: UINavigationController!
    var centerViewController: CenterViewController!
    
    var currentState: SlideOutState = .BothCollapsed {
        didSet {
            let shouldShowShadow = currentState != .BothCollapsed
            showShadowForCenterViewController(shouldShowShadow)
        }
    }
    
    var leftViewController: SidePanelViewController?
    
    // TODO: make this value dynamic
    var centerPanelExpandOffset: CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()
        centerViewController = UIStoryboard.monthViewController()
        centerViewController.delegate = self
        
        centerNavigationController = UINavigationController(rootViewController: centerViewController)
        centerNavigationController.setNavigationBarHidden(true, animated: false)
        self.view.addSubview(centerNavigationController.view)
        addChildViewController(centerNavigationController)
        
        centerNavigationController.didMoveToParentViewController(self)
        self.centerPanelExpandOffset = centerNavigationController.view.frame.width / 2
    }
    
}

extension ContainerViewController: CenterViewControllerDelegate {

    func toggleLeftPanel() {
        let notAlreadyExpanded = (currentState != .LeftPanelExpanded)
        if notAlreadyExpanded {
            addLeftPanelViewController()
        }
        
        animateLeftPanel(shouldExpand: notAlreadyExpanded)
    }
    
    func collapseSidePanel() {
    }
    
    func addLeftPanelViewController() {
        if (leftViewController == nil) {
            leftViewController = UIStoryboard.leftViewController()
            addChildSidePanelController(leftViewController!)
        }
    }
    
    func addChildSidePanelController(sidePanelController: SidePanelViewController) {
        view.insertSubview(sidePanelController.view, atIndex: 0)
        
        addChildViewController(sidePanelController)
        sidePanelController.didMoveToParentViewController(self)
    }
    
    func animateLeftPanel(#shouldExpand: Bool) {
        if shouldExpand {
            currentState = .LeftPanelExpanded
            animateCenterPanelXPosition(targetPosition: CGRectGetWidth(centerNavigationController.view.frame) - centerPanelExpandOffset)
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { finished in
                self.currentState = .BothCollapsed
                self.leftViewController!.view.removeFromSuperview()
                self.leftViewController = nil
            }
        }
    }
    
    func animateCenterPanelXPosition(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.centerNavigationController.view.frame.origin.x = targetPosition
        }, completion: completion)
    }
    
    func showShadowForCenterViewController(shouldShowShadow: Bool) {
        if shouldShowShadow {
            centerNavigationController.view.layer.shadowOpacity = 0.8
        } else {
            centerNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
    
}

private extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
    
    class func leftViewController() -> SidePanelViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("SidebarViewController") as? SidePanelViewController
    }
    
    class func monthViewController() -> CenterViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("MonthViewController") as? MonthViewController
    }
}
