//
//  HostingController.swift
//  wiretap-ios
//
//  Created by Nic Laflamme on 2020-05-01.
//  Copyright © 2020 Nic Laflamme. All rights reserved.
//

import SwiftUI


class HostingController<ContentView> : UIHostingController<ContentView> where ContentView : View {
    override dynamic open var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}
