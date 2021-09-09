//
//  TabBarVC.swift
//  AgendaZap
//
//  Created by Innovative on 30/10/20.
//  Copyright © 2020 AgendaZap. All rights reserved.
//

import UIKit
import AZTabBar

class TabBarVC: UIViewController {

    //MARK:- Variables
    var tabController:AZTabBarController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTabBar()
        self.customizationOfTabbar()
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- Functions
    func setupTabBar() {
        
        //The icons that will be displayed on the tabs that are not currently selected
        var icons = [String]()
        icons.append("ic_unselectedhome")
        icons.append("ic_unselectedpromocode")
        icons.append("ic_unselectedferramentas")
        icons.append("ic_unselectedproducts")
        icons.append("ic_unselectedprofile")

        //The icons that will be displayed for each tab once they are selected.
        var selectedIcons = [String]()
        selectedIcons.append("ic_selectedhome")
        selectedIcons.append("ic_selectedpromocode")
        selectedIcons.append("ic_selectedferramentas")
        selectedIcons.append("ic_selectedproducts")
        selectedIcons.append("ic_selectedprofile")
        
        self.tabController = .insert(into: self, withTabIconNames: icons, andSelectedIconNames: selectedIcons)

        let homeVC  = User_HomeViewController()
        let productsVC  = ProductsVC()
        let toolsVC = ToolsVC()
        let myRequestsVC = RequestListVC()
        let myStoresVC = User_MyStoresListViewController()

        self.tabController.setViewController(homeVC, atIndex: 0)
        self.tabController.setViewController(productsVC, atIndex: 1)
        self.tabController.setViewController(toolsVC, atIndex: 2)
        self.tabController.setViewController(myRequestsVC, atIndex: 3)
        self.tabController.setViewController(myStoresVC, atIndex: 4)
        
        self.tabController.setTitle(NSLocalizedString("Start", value:"Início", comment: ""), atIndex: 0)
        self.tabController.setTitle(NSLocalizedString("promocodes", value:"Promoções", comment: ""), atIndex: 1)
        self.tabController.setTitle(NSLocalizedString("tools", value:"Ferramentas", comment: ""), atIndex: 2)
        self.tabController.setTitle(NSLocalizedString("clients", value:"Clientes", comment: ""), atIndex: 3)
        self.tabController.setTitle(NSLocalizedString("profile", value:"perfil", comment: ""), atIndex: 4)
        
        self.tabController.font = UIFont(name:"MyriadPro-Light",size:12)
        
        tabController.setAction(atIndex: 0) {
        }
        
        tabController.setAction(atIndex: 1) {
        }
        
        tabController.setAction(atIndex: 2) {
        }
        
        tabController.setAction(atIndex: 3) {
        }
        
        tabController.setAction(atIndex: 4) {
        }
        
    }
    
    func customizationOfTabbar() {
        //default color of the icons on the buttons
        tabController.defaultColor = .gray

        //the color of the icon when a menu is selected
        tabController.selectedColor = .black

        //The color of the icon of a highlighted tab
        //tabController.highlightColor = .white

        //The background color of the button of the highlighted tabs.
        //tabController.highlightedBackgroundColor = .green

        //The background color of the tab bar
        //tabController.buttonsBackgroundColor = .black

        //The color of the selection indicator.
        tabController.selectionIndicatorColor = .black

        // default is 3.0
        tabController.selectionIndicatorHeight = 4

        // change the seperator line color
        //tabController.separatorLineColor = .black

        //hide or show the seperator line
        //tabController.separatorLineVisible = false

        //Enable tab change animation that looks like facebook
        tabController.animateTabChange = true
    }
    

}


//MARK:- Tabbar delegates
extension TabBarVC : AZTabBarDelegate {
    
    //func tabBar(_ tabBar: AZTabBarController, statusBarStyleForIndex index: Int)-> UIStatusBarStyle
    //func tabBar(_ tabBar: AZTabBarController, shouldLongClickForIndex index: Int)-> Bool
    //func tabBar(_ tabBar: AZTabBarController, shouldAnimateButtonInteractionAtIndex index:Int)->Bool
    func tabBar(_ tabBar: AZTabBarController, didSelectTabAtIndex index: Int)
    {
        tabBar.setIndex(index)
    }
    //func tabBar(_ tabBar: AZTabBarController, didLongClickTabAtIndex index:Int)
    //func tabBar(_ tabBar: AZTabBarController, willMoveToTabAtIndex index:Int)
    //func tabBar(_ tabBar: AZTabBarController, didMoveToTabAtIndex index: Int)

    
}
