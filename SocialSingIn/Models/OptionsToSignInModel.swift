//
//  OptionsToSignInModel.swift
//  Chilleo
//
//  Created by Nikolay Khramchenko on 5/16/18.
//  Copyright © 2018 Nikolay Khramchenko. All rights reserved.
//

import Foundation

enum OptionToSignIn: String {
    case sms = "sms";
    case fb = "facebook";
    case vk = "VK";
    case google = "google";
	case twitter = "twitter";
	case linkedIn = "linkedIn";
	case instagram = "instagram";
    
    case undefined = "";
    
    static func getName(option: OptionToSignIn) -> String {
        switch option {
        case .sms:
            return "SMS";
        case .fb:
            return "Facebook";
        case .vk:
            return "VK";
		case .google:
			return "Google";
		case .twitter:
			return "Twitter";
		case .linkedIn:
			return "LinkedIn";
		case .instagram:
			return "Instagram";
        default:
            return "";
        }
    }
}
