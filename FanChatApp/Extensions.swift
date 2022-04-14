//
//  Extensions.swift
//  FanChatApp
//
//  Created by max on 08.02.2022.
//

import UIKit
import Firebase

extension UIView {
    
    public var width: CGFloat {
        return frame.size.width
    }
    
    public var height: CGFloat {
        return frame.size.height
    }
    
    public var top: CGFloat {
        return frame.origin.y
    }
    
    public var bottom: CGFloat {
        return frame.size.height + frame.origin.y
    }
    
    public var left: CGFloat {
        return frame.origin.x
    }
    
    public var right: CGFloat {
        return frame.size.width + frame.origin.x
    }
}

//extension UIImage {
//
//    func scale(newWidth: CGFloat) -> UIImage {
//        if self.size.width == newWidth {
//            return self
//        }
//
//        let scaleFactor = newWidth / self.size.width
//        let newHeight = self.size.height * scaleFactor
//        let newSize = CGSize(width: newWidth, height: newHeight)
//
//        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
//        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
//
//        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        return newImage ?? self
//    }
//}

extension Database {
    static func fetchUserWithUID(uid: String, completion: @escaping (User) -> Void) {
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            let user = User(uid: uid, dictionary: userDictionary)
            
            print ("username:\(user.username)")
            
            completion(user)

        } withCancel: { error in
            print ("failed to fetch user: \(error)")
        }
    }
}

extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        
        let quotient: Int
        let unit: String
        if secondsAgo < minute {
            quotient = secondsAgo
            unit = "second"
        } else if secondsAgo < hour {
            quotient = secondsAgo / minute
            unit = "min"
        } else if secondsAgo < day {
            quotient = secondsAgo / hour
            unit = "hour"
        } else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = "day"
        } else if secondsAgo < month {
            quotient = secondsAgo / week
            unit = "week"
        } else {
            quotient = secondsAgo / month
            unit = "month"
        }
        
        return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
        
    }
}

