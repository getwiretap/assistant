//
//  Authentication.swift
//  wiretap-ios
//
//  Created by Nic Laflamme on 2020-04-24.
//  Copyright © 2020 Nic Laflamme. All rights reserved.
//

import FirebaseAuth


class Authentication: ObservableObject {
    
    
    @Published var uid: String?
    
    
    func listenToChanges() {
        Auth.auth().addStateDidChangeListener { (auth, maybeUser) in
            print("listen to user changes")
            if let user = maybeUser {
                self.uid = user.uid
            } else {
                self.uid = nil
            }
        }
    }
    
    
    func signIn(email: String, password: String) {
        
        // Do I really need to do anything here?
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }

            if let authResult = authResult {
                print(authResult.user.uid)
                print(strongSelf.uid ?? "nil")
            }
        }
    }
    
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
}
