//
//  Canzoni.swift
//  Audio
//
//  Created by Luca Bernardis on 05/12/23.
//

import Foundation
import UIKit

public class Song{
    var Title: [String]
    var Author: [String]
    var ImageBG: [String]

    
    init(Title: [String], Author: [String], ImageBG: [String]) {
        self.Title = Title
        self.Author = Author
        self.ImageBG = ImageBG
    }
}
