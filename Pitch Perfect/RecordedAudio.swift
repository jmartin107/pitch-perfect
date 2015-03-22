//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Jeffrey Martin on 3/12/15.
//  Copyright (c) 2015 Jeffrey Martin. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    
    var filePathUrl: NSURL
    var title: String
    
    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}
