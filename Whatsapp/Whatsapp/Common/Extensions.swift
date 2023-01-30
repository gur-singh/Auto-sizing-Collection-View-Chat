//
//  Extensions.swift
//  Whatsapp
//
//  Created by PrabSharan on 29/01/23.
//

import UIKit

@IBDesignable extension UIView {

    @IBInspectable var cornerRadius:CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
        @IBInspectable var shadowRadius: CGFloat {
            get { return layer.shadowRadius }
            set { layer.shadowRadius = newValue }
        }

        @IBInspectable var shadowOpacity: CGFloat {
            get { return CGFloat(layer.shadowOpacity) }
            set { layer.shadowOpacity = Float(newValue) }
        }

        @IBInspectable var shadowOffset: CGSize {
            get { return layer.shadowOffset }
            set { layer.shadowOffset = newValue }
        }

        @IBInspectable var shadowColor: UIColor? {
            get {
                guard let cgColor = layer.shadowColor else {
                    return nil
                }
                return UIColor(cgColor: cgColor)
            }
            set { layer.shadowColor = newValue?.cgColor }
        }
}
extension UIView {

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         self.layer.mask = mask
    }
        static var nib:UINib {
            return UINib(nibName: identifier, bundle: nil)
        }
        static var identifier:String {
            return String(describing: self)
    }

}
