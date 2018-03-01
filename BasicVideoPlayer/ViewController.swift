//
//  ViewController.swift
//  BasicVideoPlayer
//
//  Created by boris on 01/03/2018.
//  Copyright © 2018 heapoverflow. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {
    
    lazy var player : AVPlayer? = setupPlayer()
    let videoController = AVPlayerViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //MARK: UI Actions -
    @IBAction func playVideo(_ sender: AnyObject) {
        
        // 😏 check if player is not nil
        guard player != nil else {
            return
        }
        
        //hide playback controls
        videoController.showsPlaybackControls = false;
        
        //assign the player instance to playback ViewController
        videoController.player = self.player

        // Modally present the player and call the player's play() method when complete.
        present(videoController, animated: true) {
            self.player!.play()
        }
    }
    
    
    
    //MARK: Private instance methods
    @objc private func playerDidFinishPlaying(note: NSNotification){
        print(" 📺  finish playing")
        videoController.dismiss(animated: true, completion: nil)
    }

    
    
    /// Create AVPlayer object
    ///
    /// - Returns: Configured instance wich handle playback finish on playerDidFinishPlaying:  method
    private func setupPlayer() -> AVPlayer? {
        var _avPlayer : AVPlayer
        
        guard let url = URL(string: "https://devimages-cdn.apple.com/samplecode/avfoundationMedia/AVFoundationQueuePlayer_HLS2/master.m3u8") else {
            return nil
        }
        
        // create asset object to initialize AVPlayerItem
        let asset = AVAsset(url: url)
        
        // initialize AVPlayerItem with the asset previously created
        let _playerItem = AVPlayerItem(asset: asset)
        
        //create AVPlayer wich is the final object in charge of video playback.
        _avPlayer = AVPlayer(playerItem: _playerItem)
        
        //subscribe to AVPlayerItemDidPlayToEndTime of AVPlayerItem to know the play state
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.playerDidFinishPlaying(note:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: _avPlayer.currentItem)
        
        return _avPlayer
    }
  

}

