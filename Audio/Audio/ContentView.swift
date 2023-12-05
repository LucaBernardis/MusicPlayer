//
//  ContentView.swift
//  Audio
//
//  Created by Luca Bernardis on 05/12/23.
//

import SwiftUI
import AVFoundation
import UIKit
import ImageIO

public class FileList{
    var name: [String]
    
    init(name: [String]) {
        self.name = name
    }
}

public class AudioManager: NSObject, ObservableObject, AVAudioPlayerDelegate{
    
    
    @Published var audioPlayer: AVAudioPlayer?
    @Published var isPlaying =  false
    @Published var currentTime: TimeInterval = 0
    
    @State public var filename = FileList(
        name: ["Audio.mp3", "Audio_1.mp3", "Audio_2.mp3"])
 
    public var audioFileName = "Audio.mp3"
    
    override init(){
        super.init()
        setupAudio()
        starttimer()
    }
    
    func setupAudio(){
        guard let audioFileUrl = Bundle.main.url(forResource: audioFileName, withExtension: nil) else{
            print("Error")
            return
        }
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: audioFileUrl)
            audioPlayer?.prepareToPlay()
            audioPlayer?.delegate.self
        }
        catch{
            print("Error: \(error)")
        }
        
    }
    
    func playaudio(){
        audioPlayer?.play()
        isPlaying = true
    }
    
    func pauseAudio(){
        audioPlayer?.pause()
        isPlaying = false
    }
    
    func formatTime(_ timeIntervall: TimeInterval) -> String{
        let minutes = Int(timeIntervall / 60)
        let seconds = Int(timeIntervall.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d : %02d", minutes, seconds)
    }
    
    func starttimer(){
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true){
            [weak self] timer in
            guard let self = self, self.isPlaying else {return}
            self.currentTime = self.audioPlayer?.currentTime ?? 0
        }
    }
        
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        currentTime = 0
    }
    
    func next(){
        if audioFileName == filename.name[0]{
            audioFileName = filename.name[1]

        }
        else if audioFileName == filename.name[1]{
            audioFileName = filename.name[2]
        }
        else{
            audioFileName = filename.name[0]
        }
        
    }

}

struct ContentView: View {
    
    @StateObject private var audioManager = AudioManager()
    @State private var rotationAngle : Angle = .degrees(0)

    @State public var canzone = Song(
        Title: ["Forest Sound", "Nature Sound", "Ocean Sound"],
        Author: ["Io", "Tu", "Loro"],
        ImageBG: ["Forest", "Forest1", "Mountain"]
    )
    
    @State private var Title = "Start Song"
    @State private var Author = "SoundBerna"
    @State private var BackgroundImage = "Forest"
    
    var body: some View {
        VStack{
            VStack{
                Text(Title)
                    .font(.title)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(Color.white)
                    .offset(y: 45)
                Text(Author)
                    .font(.title3)
                    .fontWeight(.light)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5)
                    .foregroundStyle(Color.gray)
                    .offset(y: 45)
                
            }
            .background(
                Image(BackgroundImage)
                    .resizable()
                    .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                    .frame(width: 301, height: 603)
                    .clipped()
                    .padding(.bottom, 290)
            )
            .shadow(color: .black, radius: 50, x: 0, y: 4)
            
            Text(audioManager.formatTime(audioManager.currentTime))
                .font(
                    Font.custom("Inter", size: 20)
                        .weight(.medium)
                )
                .foregroundStyle(Color.black)
                .offset(y:200)
            ZStack{
                Rectangle()
                    .foregroundStyle(Color.clear)
                    .frame(width: 220, height: 57)
                    .background(Color.white)
                    .cornerRadius(28.5)
                    .shadow(color: .black.opacity(0.4), radius: 44, x: 0, y: 4)
                VStack{
            
                }
                .frame(width: 77, height: 77)
                .background(Color.black)
                .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: 50, x: 0, y: 4)
                .clipShape(Circle())
                
                Button(action: {
                    if audioManager.isPlaying{
                        audioManager.audioPlayer?.pause()
                    }
                    else{
                        audioManager.playaudio()
                        startSongs()
                    }
                    audioManager.isPlaying.toggle()
                }){
                    Image(systemName: audioManager.isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 33))
                        .foregroundStyle(Color.white)
                }
                HStack{
                    Button(action: {
                        audioManager.setupAudio()
                        audioManager.playaudio()
                    }) {
                        Image(systemName: "backward.fill")
                            .frame(width: 19, height: 19)
                            .foregroundStyle(Color.black)
                    }
                    .offset(x: -60)
                    
                    Button(action: {
                        audioManager.next()
                        nextSongTitle()
                        audioManager.setupAudio()
                        audioManager.playaudio()
                    }) {
                        Image(systemName: "forward.fill")
                            .frame(width: 19, height: 19)
                            .foregroundStyle(Color.black)
                    }
                    .offset(x: 60)
                }
            }
            .offset(y: 240)
        }
    }
    
    func startSongs(){
        if Title == "Start Song"{
            Title = canzone.Title[0]
            Author = canzone.Author[0]
        }
        else{
            return
        }
    }
    
    func nextSongTitle(){
        if Title == "Start Song" || Title == canzone.Title[2]{
            Title = canzone.Title[0]
            Author = canzone.Author[0]
            BackgroundImage = canzone.ImageBG[0]

        }
        else if Title == canzone.Title[0]{
            Title = canzone.Title[1]
            Author = canzone.Author[1]
            BackgroundImage = canzone.ImageBG[1]
            
        }
        else if Title == canzone.Title[1]{
            Title = canzone.Title[2]
            Author = canzone.Author[2]
            BackgroundImage = canzone.ImageBG[2]
           
        }
        
    }
    
}

#Preview {
    ContentView()
}
