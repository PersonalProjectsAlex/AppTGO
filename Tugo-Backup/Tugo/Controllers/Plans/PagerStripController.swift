//
//  PagerStripController.swift
//  Tugo
//
//  Created by Alex on 28/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import HexColors

class PagerStripController: ButtonBarPagerTabStripViewController {
    // MARK: - Let-Var
    
    // MARK: - Outlets
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        //this element might be called before super
        settings.style.selectedBarHeight = 2
        super.viewDidLoad()
        
        // setting up UI elements to be used throught the code
        setUpUI()
        
        // setting up general actions/delegates/Core
        setUPActions()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {super.viewWillAppear(true)}
    
    //Settigns Childs
    override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = Core.shared.setStoryBoardName(storyboard: K.storyboards.plan, controller: "child1", at: self)
        let child_2 = Core.shared.setStoryBoardName(storyboard: K.storyboards.plan, controller: "child1", at: self)
        let child_3 = Core.shared.setStoryBoardName(storyboard: K.storyboards.plan, controller: "child1", at: self)
        
        let childViewControllers = [child_1,child_2,child_3]
        
        return childViewControllers
    }
    
    
    // MARK: - SetUps / Funcs
    
    func setUpUI(){
        //Setting unselected item
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            
            //change contentview and textlabel colors
            oldCell?.label.textColor = .gray
            newCell?.label.textColor = .white
            
        }
    }
    
    func setUPActions(){
        //Calling Pager
        setUpPager()
        
        //Reload when tabbar item is touched
        reloadPagerTabStripView()
    }
    
    //Setting Pager
    func setUpPager(){
        settings.style.buttonBarItemBackgroundColor = .white
        buttonBarView.selectedBar.backgroundColor = HexColor(K.colors.orange)
        buttonBarView.backgroundColor = .white
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 13)
        
    }
    
}
