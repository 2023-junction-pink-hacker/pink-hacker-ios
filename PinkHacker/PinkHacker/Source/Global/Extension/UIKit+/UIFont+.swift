//
//  UIFont+.swift
//  PinkHacker
//
//  Created by Woody Lee on 2023/08/19.
//

import UIKit

enum SpotifyFontWeight {
    case normal400
    case normal500
    case normal700
}

enum GellixFontWeight {
    case medium
    case semibold
    case bold
}

extension UIFont {
    static func spotifyFont(weight: SpotifyFontWeight, size: CGFloat) -> UIFont {
        switch weight {
        case .normal400: return UIFont(name: "Circular-Spotify-Tx-T-normal-400", size: size)!
        case .normal500: return UIFont(name: "Circular-Spotify-Tx-T-normal-500", size: size)!
        case .normal700: return UIFont(name: "Circular-Spotify-Tx-T-normal-700", size: size)!
        }
    }
    
    static func gellizFont(weight: GellixFontWeight, size: CGFloat) -> UIFont {
        switch weight {
        case .medium: return UIFont(name: "Gellix-Medium", size: size)!
        case .semibold: return UIFont(name: "Gellix-SemiBold", size: size)!
        case .bold: return UIFont(name: "Gellix-Bold", size: size)!
        }
    }
}
