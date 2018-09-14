//
//  GameViewController.swift
//  FlappyClone
//
//  Created by Jared Davidson on 12/8/15.
//  Copyright (c) 2015 Archetapp. All rights reserved.
//

import UIKit
import SpriteKit
import GoogleMobileAds

class GameViewController: UIViewController, GADBannerViewDelegate, GADInterstitialDelegate {
    
    var gameScene:GameScene!
    var bannerView:GADBannerView!
    var interstitialAd:GADInterstitial!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        bannerView.delegate = self
        self.view.addSubview(bannerView)
        bannerView.adUnitID = "ca-app-pub-8624627268245517/9587831553"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.frame = CGRect(x: 0, y: view.bounds.height - bannerView.frame.size.height, width: bannerView.frame.size.width, height: bannerView.frame.size.height)
        
        //NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.createAndLoadInterstitial), name: NSNotification.Name(rawValue: "createAndLoadInsterstitial"), object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.interstitialDidReceiveAd(_:)), name: NSNotification.Name(rawValue: "interstitialDidReceiveAd"), object: nil)

        interstitialAd = createAndLoadInterstitial()
        
        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill
            scene.size = self.view.bounds.size
            
            skView.presentScene(scene)
        }
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let request = GADRequest()
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-8624627268245517/4557854394")
        interstitial.delegate = self
        interstitial.load(request)
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitialAd = createAndLoadInterstitial()
    }
    

    
    func interstitialDidReceiveAd(_ ad: GADInterstitial!) {
        if (self.interstitialAd?.isReady)! && showAd == true {
            print("Show interstitial")
            interstitialAd?.present(fromRootViewController: self)
        }
        else {
            interstitialAd = createAndLoadInterstitial()
            print("showAd = \(showAd)")
            print("Ad wasn't ready")
        }
    }
    
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
}
