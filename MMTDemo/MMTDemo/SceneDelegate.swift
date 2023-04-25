//
//  SceneDelegate.swift
//  MMTDemo
//
//  Created by mradulatray on 01/04/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
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
//
//
//func findPair(arr: [Int], target: Int) -> [Int]? {
//    var dict:[Int: Int] = [:]
//    for value in arr {
//        dict[value] = target - value
//    }
//    for (index,value) in arr.enumerated() {
//        var keys: Int?
//        let isExist = dict.contains { (key: Int, val: Int) in
//            if value == val {
//                keys = key
//                return true
//            }
//            return false
//        }
//        
//        if isExist {
//            print("key\(keys ?? 0), value\(value)")
//        }
//        
//    }
//    return nil
//}
//
//func findPairsOfArrayElementsWhoseValueEqualToSum() -> [(Int, Int)] {
//    var result = [(Int, Int)]()
//    var dict = [Int: Int]()
//    for (index, value) in arr.enumerated() {
//        let complement = sum - value
//        if let complementIndex = dict[complement] {
//            result.append((complementIndex, index))
//        }
//        dict[value] = index
//    }
//    return result
//}
//
//func findTheCountPairOfArrayElementWhoseValueEqualToSum(){
////        let arr = [1,1,1,1]//[0, -1, 2, -3, 1,-1]
////        let sum = 2//-2
//    var dict:[Int:Int] = [:]
//    for val in arr {
//        dict[val] = target - val
//    }
//
//    for val in arr {
//        var keyss: Int?
//        let a = dict.contains { (key,value) in
////                print(val,value,key)
//            if(val == value){
//                keyss = key
//                return true
//            } else {
//                keyss = nil
//                return false
//            }
//        }
//        if a == true {
//            if let key = keyss{
//                print("(val-1) \(val) (val-2) \(key)")
//            }
//        }
//    }
//    
//}
