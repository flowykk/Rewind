//
//  SceneDelegate.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 18.02.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        guard let windowScene = scene as? UIWindowScene else { return }
        guard let window = windowScene.windows.first else { return }
        
        LoadingView.show(inVC: window.rootViewController, backgroundColor: .white)
        
        let rootVC = RewindBuilder.build()
        window.rootViewController = UINavigationController(rootViewController: rootVC)
        self.window = window
        
        if let url = userActivity.webpageURL {
            if
                let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                let ecryptedGroupIdToJoin = components.queryItems?.first?.value
            {
                guard let decryptedGroupIdToJoin = JoinLinkService.decrypt(encryptedString: ecryptedGroupIdToJoin) else { return }
                let userId = UserDefaults.standard.integer(forKey: "UserId")
                
                NetworkService.addMemberToGroup(groupId: decryptedGroupIdToJoin, userId: userId) { response in
                    if
                        response.success,
                        let json = response.json,
                        let groupToJoin = Group(json: json)
                    {
                        DataManager.shared.setCurrentGroup(groupToJoin)
                        DispatchQueue.main.async {
                            let groupVC = GroupBuilder.build()
                            rootVC.navigationController?.pushViewController(groupVC, animated: true)
                            LoadingView.hide(fromVC: window.rootViewController)
                        }
                    } else {
                        print("something went wrong")
                        print(response)
                    }
                    DispatchQueue.main.async {
                        LoadingView.hide(fromVC: window.rootViewController)
                    }
                }
            }
        }
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let initialViewController = LaunchBuilder.build()
        let isUserIDStored = UserDefaults.standard.object(forKey: "UserId")
        
        window.rootViewController = UINavigationController(rootViewController: initialViewController)
        self.window = window
        window.makeKeyAndVisible()
        
        if isUserIDStored != nil {
            if let url = connectionOptions.userActivities.first?.webpageURL {
                LoadingView.show(inVC: initialViewController, backgroundColor: .white)
                
                if
                    let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                    let ecryptedGroupIdToJoin = components.queryItems?.first?.value
                {
                    guard let decryptedGroupIdToJoin = JoinLinkService.decrypt(encryptedString: ecryptedGroupIdToJoin) else { return }
                    let userId = UserDefaults.standard.integer(forKey: "UserId")
                    NetworkService.addMemberToGroup(groupId: decryptedGroupIdToJoin, userId: userId) { response in
                        if response.success, let json = response.json {
                            guard let group = Group(json: json) else { return }
                            DataManager.shared.setCurrentGroup(group)
                            DispatchQueue.main.async {
                                let groupVC = GroupBuilder.build()
                                initialViewController.navigationController?.pushViewController(groupVC, animated: true)
                                LoadingView.hide(fromVC: initialViewController)
                            }
                        } else {
                            print("something went wrong")
                            print(response)
                        }
                        DispatchQueue.main.async {
                            LoadingView.hide(fromVC: initialViewController)
                        }
                    }
                }
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}
