//
//  MemeModel.swift
//  All-Bout Meme
//
//  Created by Stephen Martinez on 1/13/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import UIKit

// The meme object to be instantiated when saving a meme.
struct Meme {
    let upperEntry: String
    let lowerEntry: String
    let originalImage: UIImage
    let memeImage: UIImage
}
    
//Singleton Object for sharing model across MVC's.
class SentMemes{
    var memesList = [Meme]()
    static let shared = SentMemes()
    private init(){}
    class func clearMemes(){SentMemes.shared.memesList = [Meme]()}
    //Possible idea for clearing out sent memes if needed.
}

enum Styles: Int{ case Meme, Schooled, Industrial, Typewriter, Notes, Handwritten, LoveLetter}

enum SampleSize: Int{case Big, Small}

struct MemeStyle{
    
    let menu: [(styleType: Styles, displayName: String, description: String)] = [(.Meme,"Meme", "The original look, style, and feel of Meme"),
                                                                                 (.Schooled,"Schooled", "Reminiscent of \"I will not...\" 100x's on the chalboard"),
                                                                                 (.Industrial,"Industrial","Cold hard stamped out steel letters"),
                                                                                 (.Typewriter,"Typewriter","An old-school report with your Momma's old Typewritter"),
                                                                                 (.Notes,"Notes", "A quick jot to keep those thoughts on some scratch paper"),
                                                                                 (.Handwritten,"Handwritten", "It's personal and you wanna show it writting it yourself"),
                                                                                 (.LoveLetter,"Love Letter", "Dust off that caligraphy pen and let the ink flow for your heart-throb")]
    
    func configure(_ firstEntry: UITextField, _ secondEntry: UITextField, _ selectedStyle: Styles) -> (first: UITextField, second: UITextField){
        var font = "HelveticaNeue-CondensedBlack"
        var fontSize: CGFloat = 40
        var outlineSize = -0.9
        
        switch selectedStyle{
        case .Meme:
            font = "HelveticaNeue-CondensedBlack"
            fontSize = 40
            outlineSize = -0.9
        case .Schooled:
            font = "Chalkduster"
            fontSize = 42
            outlineSize = -0.1
        case .Industrial:
            font = "Copperplate-Bold"
            fontSize = 44
            outlineSize = -0.5
        case .Typewriter:
            font = "AmericanTypewriter"
            fontSize = 40
            outlineSize = -0.5
        case .Notes:
            font = "Noteworthy-Bold"
            fontSize = 40
            outlineSize = -0.7
        case .Handwritten:
            font = "BradleyHandITCTT-Bold"
            fontSize = 44
            outlineSize = -0.9
        case .LoveLetter:
            font = "SnellRoundhand-Black"
            fontSize = 44
            outlineSize = -0.2
        }
        
        let myTextStyle: [String: Any] = [NSStrokeColorAttributeName : UIColor.black, NSForegroundColorAttributeName : UIColor.white,
                                          NSFontAttributeName : UIFont(name: font, size: fontSize)!, NSStrokeWidthAttributeName: outlineSize]
        
        firstEntry.defaultTextAttributes = myTextStyle
        secondEntry.defaultTextAttributes = myTextStyle
        firstEntry.textAlignment = .center
        secondEntry.textAlignment = .center
        
        return (first: firstEntry, second: secondEntry)
    }
    
    func fontForStyle(_ selectedStyle: Styles, size: SampleSize) -> (UIFont){
        var font = "HelveticaNeue-CondensedBlack"
        var fontSize: CGFloat = 24
        
        switch (selectedStyle, size){
        case (.Meme, .Big):
            font = "HelveticaNeue-CondensedBlack"
            fontSize = 30
        case (.Meme, .Small):
            font = "HelveticaNeue-CondensedBlack"
            fontSize = 18
        case (.Schooled, .Big):
            font = "Chalkduster"
            fontSize = 30
        case (.Schooled, .Small):
            font = "Chalkduster"
            fontSize = 18
        case (.Industrial, .Big):
            font = "Copperplate-Bold"
            fontSize = 30
        case (.Industrial, .Small):
            font = "Copperplate-Bold"
            fontSize = 18
        case (.Typewriter, .Big):
            font = "AmericanTypewriter"
            fontSize = 30
        case (.Typewriter, .Small):
            font = "AmericanTypewriter"
            fontSize = 18
        case (.Notes, .Big):
            font = "Noteworthy-Bold"
            fontSize = 30
        case (.Notes, .Small):
            font = "Noteworthy-Bold"
            fontSize = 18
        case (.Handwritten, .Big):
            font = "BradleyHandITCTT-Bold"
            fontSize = 30
        case (.Handwritten, .Small):
            font = "BradleyHandITCTT-Bold"
            fontSize = 18
        case (.LoveLetter, .Big):
            font = "SnellRoundhand-Black"
            fontSize = 30
        case (.LoveLetter, .Small):
            font = "SnellRoundhand-Black"
            fontSize = 18
        }
        let configuredFont = UIFont(name: font, size: fontSize)
        return configuredFont!
    }
}

//Protocol for passing data backwards through Navagation VC Stack.
protocol StyleSelectionDelegate: class{
    func didSelectStyle(_ styleSelected: Styles)
}














