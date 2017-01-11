//
//  ViewController.swift
//  AnalyticsSample
//
//  Created by Oded Klein on 27/11/2016.
//  Copyright © 2016 Kaltura. All rights reserved.
//

import UIKit
import PlayKit
import AVFoundation

class ViewController: UIViewController {

    var playerController: Player!

    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var progressBar: UISlider!
    @IBOutlet weak var durationTimeText: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        PlayKitManager.sharedInstance.registerPlugin(YouboraPlugin.self)

        setupVideo()
    
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let controller = self.playerController {
            controller.view.frame = CGRect(origin: CGPoint.zero, size: playerView.frame.size)
        }
    }

    func setupVideo() {
        
        let config = PlayerConfig()
        
        var source = [String : Any]()
        source["id"] = "123123" //"http://media.w3.org/2010/05/sintel/trailer.mp4"
        source["url"] = "http://media.w3.org/2010/05/sintel/trailer.mp4"
        
        var sources = [JSON]()
        sources.append(JSON(source))
        
        var entry = [String : Any]()
        entry["id"] = "Trailer"
        entry["sources"] = sources
        
        config.set(mediaEntry: MediaEntry(json: JSON(entry)))//.set(allowPlayerEngineExpose: kAllowAVPlayerExpose)
        
        var plugins = [String : AnyObject?]()
        
        let analyticsConfig = AnalyticsConfig()
        
        
        plugins[YouboraPlugin.pluginName] = analyticsConfig
        config.plugins = plugins

        
        self.playerController = PlayKitManager.sharedInstance.loadPlayer(config: config)
        playerView.addSubview(self.playerController.view)

        self.playerController.addObserver(self, events: [PlayerEvents.canPlay.self, PlayerEvents.play.self], block: {(info) in
            
            PKLog.debug("Duration: \(self.playerController.duration)")
            
            })
    }
    
    @IBAction func playClicked(_ sender: AnyObject) {
        self.playerController.play()
    }
    
    @IBAction func pauseClicked(_ sender: AnyObject) {
        self.playerController.pause()
    }
    
    @IBAction func playheadValueChanged(_ sender: AnyObject) {
        if (!sender.isKind(of: UISlider.self)) {
            return
        }
        let slider = sender as! UISlider
        playerController.seek(to: CMTimeMake(Int64(slider.value), 1))
    }

    
}
