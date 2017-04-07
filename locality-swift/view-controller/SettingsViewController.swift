//
//  SettingsViewController.swift
//  locality-swift
//
//  Created by Chelsea Power on 4/6/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

class SettingsViewController: LocalityBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        initHeaderView()
    }

    func initHeaderView() {
        header.initHeaderViewStage()
        header.initAttributes(title: "", leftType: .hamburger, rightType: .none)
        header.backgroundColor = .clear
        view.addSubview(header)
    }

}
