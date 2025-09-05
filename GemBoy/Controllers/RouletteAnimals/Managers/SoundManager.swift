//
//  SoundManager.swift
//  FarmSound
//
//  Created by Domenico Gonnelli on 07/09/2019.
//  Copyright © 2019 Domenico Gonnelli. All rights reserved.
//

import Foundation

class SoundManager {
    
    private static var _instance : SoundManager?
    
    public static var instance : SoundManager{
        get{
            if(_instance == nil){
                _instance = SoundManager()
            }
            return _instance!
        }
    }
    
    
    func saveSoundFile(url: URL?){
        
        if let audioUrl = url{
            
            // then lets create your document folder url
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
            print(destinationUrl)
            
            // to check if it exists before downloading it
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                print("The file already exists at path")
                
                // if the file doesn't exist
            } else {
                
                // you can use NSURLSession.sharedSession to download the data asynchronously
                URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) -> Void in
                    guard let location = location, error == nil else { return }
                    do {
                        // after downloading your file you need to move it to your destination url
                        try FileManager.default.moveItem(at: location, to: destinationUrl)
                        print("File moved to documents folder")
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }).resume()
            }
        }
        
    }
    
    func getSoundFile(animalSoundPath: String, completion: @escaping (URL?)->()){
        // then lets create your document folder url
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
     // lets create your destination file url
        completion(documentsDirectoryURL.appendingPathComponent(animalSoundPath))
        //let url = Bundle.main.url(forResource: destinationUrl, withExtension: "mp3")!
    }
    
    func checkExistingAudio(audioPath: String) -> Bool {
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = documentsDirectoryURL.appendingPathComponent(audioPath)
        let filePath = url.path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            return true
        }
        return false
    }
    
    
    
}
