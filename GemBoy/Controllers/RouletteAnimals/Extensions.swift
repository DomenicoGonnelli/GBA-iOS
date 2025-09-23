//
//  Extensions.swift
//  FarmSound
//
//  Created by Domenico Gonnelli on 03/09/2019.
//  Copyright © 2019 Domenico Gonnelli. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit
import AVFoundation
import MediaPlayer
import Kingfisher
import Lottie

extension CGSize {
    var innerRadius: CGFloat { return min(width, height) / 2.0 }
}


@IBDesignable
extension UIView{
    
    func roundLayer(){
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.borderWidth = 0
    }
}


extension UIView {
    
    func startRotation(duration: TimeInterval, numberOfElement : Int, otherView: UIView, _ function: @escaping (Int)->()){
        var j = 0
        UIView.animate(withDuration: duration, delay: 0, animations:{
            
            var angleSum = CGFloat(0)
            
            for _ in 0..<35 {
                let randomAngle = CGFloat.pi*CGFloat(Double.random(in: 1.55..<1.94))
                self.transform = self.transform.rotated(by: randomAngle)
                otherView.transform = otherView.transform.rotated(by: randomAngle)
                angleSum += randomAngle
            }
            
            if let thisView = self as? UICollectionView {
                for i in 0..<numberOfElement {
                    if let cell = thisView.cellForItem(at: IndexPath(item: i, section: 0)) as? RouletteCell {
                        cell.updateAngle(theta: angleSum)
                    }
                }
            
                var littleAngle = CGFloat(0)
                
                for i in 0..<numberOfElement {
                    let cell =  thisView.cellForItem(at: IndexPath(item: i, section: 0)) as! RouletteCell
                    let angle = cell.angle.remainder(dividingBy: 2*CGFloat.pi)
                    
                    littleAngle = i==0 ? angle : littleAngle
                    
                    if abs(angle) < abs(littleAngle) {
                        j = i
                        littleAngle = angle
                    }
                }
                thisView.transform = thisView.transform.rotated(by: littleAngle)
                otherView.transform = otherView.transform.rotated(by: littleAngle)
                for cell in thisView.visibleCells {
                    (cell as! RouletteCell).updateAngle(theta: littleAngle)
                }
            }
        }){ _ in
            function(j)
        }
        
    }
    
}
extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow((point.x - x), 2) + pow((point.y - y), 2))
    }
}





extension UIColor {
    
    static let bourdeax = UIColor(hexString: "#662515")
    
    convenience init(hexString:String) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format:"#%06x", rgb)
    }
    
}


extension UIImageView {
    
    func setAnimalImage(forName animal: AnimalModel,isTransparent: Bool){
       if ImageManager.isImageStored(animal: animal, isTransparent: isTransparent){
            self.image = ImageManager.reloadImage(animal: animal, isTransparent: isTransparent)
        } else {
            let imageCartoon = isTransparent ? animal.urlCartoonTr : animal.urlCartoon
            let url = "animalImage/Cartoon/\(imageCartoon)"
            StorageHelper.getUrlImage(url){ url in
                guard let url = url else { self.image = UIImage(named: ""); return}
                self.setImage(for: animal, with: url, isTransparent)
            }
        }
    }
    
    func setImage(for animal: AnimalModel, with: URL,_ isTransparent: Bool){
        self.kf.setImage(with: with, placeholder: nil, completionHandler: { result in
            do{
                let img = try result.get().image
                ImageManager.storeImage(animal: animal, image: img.pngData(), isTransparent: isTransparent)
            }
            catch {
                print(error.localizedDescription)
            }
        })
    }
    
    
}

extension AnimalBaseViewController{
    
    func playSound(for animal: AnimalModel) {
        
        let urlSound = animal.urlSound
        if SoundManager.instance.checkExistingAudio(audioPath: urlSound){
            SoundManager.instance.getSoundFile(animalSoundPath: urlSound){ url in
               // if let vc = self as? BaseViewController {
                    guard let url = url else {
                        print("error in Sound Manager - get url")
                        return
                    }
                    do {
                        if(SettingManager.sound < 0.05){
                            self.showAlerOk(title: "Warning".localizable, message: "sound_level_error".localizable)
                            return
                        }

                        self.avPlayer = try AVAudioPlayer(contentsOf: url)
                        self.avPlayer?.delegate = self
                        guard let player = self.avPlayer else { return }
                        try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                        player.prepareToPlay()
                        player.play()
                        
                    
                        
                    } catch let error {
                        //show error
                        print(error.localizedDescription)
                    }
                //}
            }
        } else {
            saveAndPlayAudio(for: animal)
        }
    }
    
    func saveAndPlayAudio(for animal: AnimalModel){
        let url = "animalSound/\(animal.urlSound)"
        StorageHelper.getUrlSound(url){url in
            SoundManager.instance.saveSoundFile(url: url)
            
            self.playSound(for: animal)
        }
        
    }
    
}

/*extension MPVolumeView {
    static func setVolume(_ volume: Float) {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            slider?.value = volume
        }
    }
}
*/
extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}



extension CGRect {
    init(center: CGPoint, size: CGSize) {
        self.init(x: center.x - size.width / 2.0, y: center.y - size.height / 2.0, width: size.width, height: size.height)
    }
    
}


