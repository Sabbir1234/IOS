//
//  SoundStory.swift
//  music_library
//
//  Created by Twinbit LTD on 24/11/20.
//

import Foundation


struct SoundStory: Decodable {
    let category, trackName: String
    let thumbPath: String
    let trackPath: String
    let artistName: String
    let isStory, duration: Int
}

struct Story: Decodable {
    var soundstories : [SoundStory]
}


