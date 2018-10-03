//
//  PlayerDetailsViewcontroller.swift
//  PodCastApp
//
//  Created by Sherif  Wagih on 9/29/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer

class PlayerDetailsView: UIView{
    
    var episode:Episode?{
        didSet{
            if let author = episode?.author
            {
                authorLabel.text = author
            }
            
            if let title = episode?.title
            {
                episodeTitleLabel.text = title
                miniPlayerEpisodeTitleLabel.text = title
            }
            if let imageURL = episode?.imageURL
            {
                let secureURL = imageURL
                episodeImage.sd_setImage(with: URL(string: secureURL)) { (image, err, cachetype, url) in
                    if err != nil
                    {
                        if let backUpURL = self.episode?.backUpURL
                        {
                            self.episodeImage.sd_setImage(with: URL(string:backUpURL), completed: nil)
                        }
                    }
                    self.episodeImage.sd_showActivityIndicatorView()
                }
                miniPlayerEpisodeImage.sd_setImage(with: URL(string: secureURL)) { (image, err, cachetype, url) in
                    if err != nil
                    {
                        if let backUpURL = self.episode?.backUpURL
                        {
                            self.miniPlayerEpisodeImage.sd_setImage(with: URL(string:backUpURL), completed: nil)
                        }
                    }
            self.miniPlayerEpisodeImage.sd_showActivityIndicatorView()
                }
            }
            else
            {
                if let backUpURL = self.episode?.backUpURL
                {
                    self.episodeImage.sd_setImage(with: URL(string:backUpURL), completed: nil)
                    self.miniPlayerEpisodeImage.sd_setImage(with: URL(string:backUpURL), completed: nil)
                    return
                }
                episodeImage.image = #imageLiteral(resourceName: "noimage")
                miniPlayerEpisodeImage.image = #imageLiteral(resourceName: "noimage")
                
            }
            playEpisode()
        //    setupNowPlayingInfo()
        }
    }
    fileprivate func setupNowPlayingInfo()
    {
        var lockScreenInfo = [String:Any]()
        var nowPlayingInfo =  MPNowPlayingInfoCenter.default().nowPlayingInfo
        lockScreenInfo[MPMediaItemPropertyTitle] = episode?.title
        lockScreenInfo[MPMediaItemPropertyArtist] = episode?.author
        nowPlayingInfo![MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: #imageLiteral(resourceName: "podCastIcon").size , requestHandler: { (_) -> UIImage in
            return #imageLiteral(resourceName: "podCastIcon")
        })
        nowPlayingInfo = lockScreenInfo
        
        
    }
    lazy var dismissLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Dismiss"
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleControlDismiss)))
        return label
    }()
    @objc func handleControlDismiss()
    {
        let rootController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
        rootController?.maximizePlayerView(maximize: false)
        panGestureRecognizer.isEnabled = true
    }
    let episodeImage:UIImageView = {
        let eImage = UIImageView()
        eImage.translatesAutoresizingMaskIntoConstraints = false
        eImage.image = #imageLiteral(resourceName: "podCastIcon")
        eImage.contentMode = .scaleAspectFill
        eImage.sd_setIndicatorStyle(.gray)
        eImage.sd_setShowActivityIndicatorView(true)
        eImage.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        eImage.clipsToBounds = true
        eImage.layer.cornerRadius = 12
        return eImage
    }()
    let miniPlayerEpisodeImage:UIImageView = {
        let eImage = UIImageView()
        eImage.translatesAutoresizingMaskIntoConstraints = false
        eImage.image = #imageLiteral(resourceName: "podCastIcon")
        eImage.contentMode = .scaleAspectFill
        eImage.sd_setIndicatorStyle(.gray)
        eImage.sd_setShowActivityIndicatorView(true)
        eImage.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        eImage.clipsToBounds = true
        eImage.layer.cornerRadius = 12
        return eImage
    }()
    lazy var playerSlider : UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(handleVideoTimeSeekSlider), for: .valueChanged)
        return slider
    }()
    
    let episodeTitleLabel:UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let miniPlayerEpisodeTitleLabel:UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let authorLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .purple
        label.textAlignment = .center
        return label
    }()
    
    lazy var containerStackView : UIStackView = {
        let stack = UIStackView(arrangedSubviews: [dismissLabel,episodeImage,playerSlider,timerStackView,episodeTitleLabel,authorLabel,controlsContainerStackView,volumeController])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 2
        return stack
    }()
    
    lazy var rewind15Button:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "rewind15"), for: .normal)
        button.addTarget(self, action: #selector(seek15Less), for: .touchUpInside)
        return button
    }()
    
    lazy var fastforward15Button:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "fastforward15"), for: .normal)
        button.addTarget(self, action: #selector(seek15More), for: .touchUpInside)
        return button
    }()
    
    lazy var miniPlayerFastforward15Button:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "fastforward15"), for: .normal)
        button.addTarget(self, action: #selector(seek15More), for: .touchUpInside)
        button.tintColor = .black
        return button
    }()
    
    lazy var playPauseButton:UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        button.isEnabled = false
        return button
    }()
    
    lazy var miniPlayerPlayPauseButton:UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        button.isEnabled = false
        return button
    }()
    
    lazy var controlsContainerStackView:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [rewind15Button,playPauseButton,fastforward15Button])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        return stack
    }()
    let maxVolumeButton:UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "max_volume"), for: .normal)
        return button
    }()
    let minVolumeButton:UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "muted_volume"), for: .normal)
        return button
    }()
    lazy var volumeSlider:UISlider = {
        let slider = UISlider()
        slider.value = 1
        slider.addTarget(self, action: #selector(setVolume), for: .valueChanged)
        return slider
    }()
    lazy var volumeController:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [minVolumeButton,volumeSlider,maxVolumeButton])
        stack.axis = .horizontal
        return stack
    }()
    
    let realTimeLabel:UILabel = {
        let label = UILabel()
        label.text = "--:--"
        label.textAlignment = .left
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let fullTimeLabel:UILabel = {
        let label = UILabel()
        label.text = "--:--:--"
        label.textAlignment = .right
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var timerStackView:UIStackView = {
        let timer = UIStackView(arrangedSubviews: [realTimeLabel,fullTimeLabel])
        return timer
    }()
    let player:AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    let miniPlayerView:UIView = {
        let miniPlayer = UIView()
        miniPlayer.translatesAutoresizingMaskIntoConstraints = false
        //miniPlayer.backgroundColor = .lightGray
        miniPlayer.alpha = 0
        return miniPlayer
    }()
    let separatorMiniPlayerView:UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor(white:0.85,alpha:1)
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }()
    lazy var miniPlayerControl:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [miniPlayerEpisodeImage,miniPlayerEpisodeTitleLabel,miniPlayerPlayPauseButton,miniPlayerFastforward15Button])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 4
        return stack
    }()
    fileprivate func playerObservers()
    {
        enableDisableControls(enable: false)
        let time = CMTimeMake(1,3)
        let times = [NSValue(time:time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) {
            [weak self] in
            self?.enableDisableControls(enable: true)
            self?.playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            self?.miniPlayerPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            self?.modifyImageView(1)
        }
        let interval = CMTimeMake(1, 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self](time) in
            let duration = time.toDisplayString()
            self?.realTimeLabel.text = "\(duration)"
            self?.fullTimeLabel.text = self?.player.currentItem?.duration.toDisplayString()
            self?.updatePlayerSlider()
        }
    }
    func updatePlayerSlider()
    {
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let duration = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(1, 1))
        let percentage = currentTime / duration
        playerSlider.value = Float(percentage)
    }
    lazy var activityIndicator:UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activity.startAnimating()
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    fileprivate func playEpisode()
    {
        if let url = episode?.streamURL
        {
            guard let actualURL = URL(string: url) else {return}
            let item = AVPlayerItem(url: actualURL)
            player.replaceCurrentItem(with: item)
            player.play()
        }
    }
    fileprivate func modifyImageView(_ scale:CGFloat)
    {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.episodeImage.transform = CGAffineTransform(scaleX: scale, y: scale)
            self.miniPlayerEpisodeImage.transform = CGAffineTransform(scaleX: scale, y: scale)
        }, completion: nil)
    }
    @objc func handlePlayPause()
    {
        if player.timeControlStatus == .paused
        {
            player.play()
            modifyImageView(1)
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            miniPlayerPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        }
        else
        {
            player.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            miniPlayerPlayPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            modifyImageView(0.7)
        }
    }
    
    @objc func handleVideoTimeSeekSlider()
    {
        if let duration = player.currentItem?.duration
        {
            let totalSeconds = duration.seconds
            let value = Float(playerSlider.value) * Float(totalSeconds)
            let cmTime = CMTime(value: CMTimeValue(value), timescale: 1)
            player.seek(to: cmTime, completionHandler: { (completed) in
                self.player.play()
            })
        }
    }
    
    func enableDisableControls(enable:Bool)
    {
        if enable
        {
            activityIndicator.stopAnimating()
        }
        else
        {
            self.activityIndicator.startAnimating()
        }
        
        playPauseButton.isEnabled = enable
        
        playerSlider.isEnabled = enable
        
        fastforward15Button.isEnabled = enable
        
        rewind15Button.isEnabled = enable
        
        miniPlayerPlayPauseButton.isEnabled = enable
        miniPlayerFastforward15Button.isEnabled = enable
        
    }
    @objc func seek15More()
    {
        seekToTime(time:15)
    }
    @objc func seek15Less()
    {
        seekToTime(time: -15)
    }
    @objc func setVolume()
    {
        player.volume = volumeSlider.value
    }
    func seekToTime(time:Int64)
    {
        let fifteenSeconds = CMTimeMake(time, 1)
        let seekTime = CMTimeAdd(player.currentTime(), fifteenSeconds)
        player.seek(to: seekTime)
    }
    var panGestureRecognizer:UIPanGestureRecognizer!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        playerObservers()
        setupAllGestures()
        setupAudioSession()
        setupRemoteControl()
    }
    fileprivate func setupRemoteControl()
    {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.handlePlayPause()
            return .success
        }
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.handlePlayPause()
            return .success
        }
        commandCenter.togglePlayPauseCommand.isEnabled = true
        commandCenter.togglePlayPauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.handlePlayPause()
            return .success
        }
    }
    fileprivate func setupAudioSession()
    {
        do
        {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch
        {
            print("Error setting session")
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews()
    {
        backgroundColor = .white
        addSubview(containerStackView)
        addSubview(activityIndicator)
        addSubview(miniPlayerView)
        miniPlayerView.addSubview(miniPlayerControl)
        miniPlayerView.addSubview(separatorMiniPlayerView)
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            containerStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -24),
            episodeImage.widthAnchor.constraint(equalTo: episodeImage.heightAnchor, multiplier: 1),
            dismissLabel.heightAnchor.constraint(equalToConstant: 44),
            playerSlider.heightAnchor.constraint(equalToConstant: 44),
            authorLabel.heightAnchor.constraint(equalToConstant: 40),
            episodeTitleLabel.heightAnchor.constraint(equalToConstant: 50),
            realTimeLabel.heightAnchor.constraint(equalToConstant: 20),
            fullTimeLabel.heightAnchor.constraint(equalToConstant: 20),
            activityIndicator.heightAnchor.constraint(equalTo: playPauseButton.heightAnchor),
            activityIndicator.widthAnchor.constraint(equalTo: playPauseButton.widthAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: playPauseButton.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: playPauseButton.centerYAnchor,constant:-25),
            playPauseButton.heightAnchor.constraint(equalToConstant: 55),
            miniPlayerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            miniPlayerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            miniPlayerView.heightAnchor.constraint(equalToConstant: 64),
            miniPlayerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            miniPlayerControl.topAnchor.constraint(equalTo: miniPlayerView.topAnchor,constant:5),
            miniPlayerControl.leadingAnchor.constraint(equalTo: miniPlayerView.leadingAnchor,constant:5),
            miniPlayerControl.trailingAnchor.constraint(equalTo: miniPlayerView.trailingAnchor,constant:5),
            miniPlayerControl.bottomAnchor.constraint(equalTo: miniPlayerView.bottomAnchor,constant:-5),
            miniPlayerFastforward15Button.widthAnchor.constraint(equalToConstant: 55),
            miniPlayerPlayPauseButton.widthAnchor.constraint(equalToConstant: 55),         miniPlayerEpisodeImage.widthAnchor.constraint(equalToConstant: 55),
            separatorMiniPlayerView.topAnchor.constraint(equalTo: miniPlayerView.topAnchor),
            separatorMiniPlayerView.leadingAnchor.constraint(equalTo: miniPlayerView.leadingAnchor),
            separatorMiniPlayerView.trailingAnchor.constraint(equalTo: miniPlayerView.trailingAnchor),
            separatorMiniPlayerView.heightAnchor.constraint(equalToConstant: 0.5)
            ])
    }
}
