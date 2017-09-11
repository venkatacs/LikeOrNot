//
//  CardView.swift
//  LikeOrNot
//
//  Created by surya on 9/5/17.
//  Copyright © 2017 surya. All rights reserved.
//

import UIKit

public enum CardOption: String{
    case like1 = "Like"
    case like2 = "Super Like"
    case like3 = "Hyper Like"
    
    case dislike1 = "No"
    case dislike2 = "Not ok"
    case dislike3 = "Never"
}


class CardView: UIView{
    
    var greenLabel: CardViewLabel!
    var redLabel: CardViewLabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //style
        
        self.backgroundColor = UIColor(red: 80/255, green: 100/255, blue: 200/255, alpha: 1.0)
        self.layer.cornerRadius = 10
        
        // labels
        
        let padding: CGFloat = 20
        
        greenLabel = CardViewLabel(origin: CGPoint(x: padding, y: padding), color: UIColor(red: 100/255, green: 210/255, blue: 160/255, alpha: 1.0))
        greenLabel.isHidden = true
        self.addSubview(greenLabel)
        
        redLabel = CardViewLabel(origin: CGPoint(x: frame.width - CardViewLabel.size.width - padding, y: padding), color: UIColor(red: 240/255, green: 140/255, blue: 140/255, alpha: 1.0))
        redLabel.isHidden = true
        self.addSubview(redLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showOptionLabel(option: CardOption){
        if option == .like1 || option == .like2 || option == .like3 {
            greenLabel.text = option.rawValue
            
            //redLabel fadeout
            
            if !redLabel.isHidden {
                UIView.animate(withDuration: 0.15, animations: {
                    self.redLabel.alpha = 0
                }, completion: {
                    (_) in
                    self.redLabel.isHidden = true
                })
            }
            
            if greenLabel.isHidden {
                greenLabel.alpha = 0
                greenLabel.isHidden = false
                UIView.animate(withDuration: 0.2, animations: {
                    self.greenLabel.alpha = 1
                })
            }
            
        } else {
            redLabel.text = option.rawValue
            
            //greenlabel fade out
            if !greenLabel.isHidden {
                UIView.animate(withDuration: 0.15, animations: {
                    self.greenLabel.alpha = 0
                }, completion: {
                    (_) in
                    self.greenLabel.isHidden = true
                })
            }
            
            if redLabel.isHidden {
                redLabel.alpha = 0
                redLabel.isHidden = false
                UIView.animate(withDuration: 0.2, animations: {
                    self.redLabel.alpha = 1
                })
            }
        }
    }
    
    var isHidingOptionLabel = false
    
    func hideOptionLabel() {
        // greenlabel fade out
        if !greenLabel.isHidden{
            if isHidingOptionLabel { return }
            isHidingOptionLabel = true
            UIView.animate(withDuration: 0.15, animations: {
                self.greenLabel.alpha = 0
            }, completion: {
                (_) in
                self.greenLabel.isHidden = true
                self.isHidingOptionLabel = false
            })
        }
        
        // redlabel fade out
        if !redLabel.isHidden{
            if isHidingOptionLabel { return }
            isHidingOptionLabel = true
            UIView.animate(withDuration: 0.15, animations: {
                self.redLabel.alpha = 0
            }, completion: {
                (_) in
                self.redLabel.isHidden = true
                self.isHidingOptionLabel = false
            })
        }
    }
    
}

class CardViewLabel: UILabel {
    fileprivate static let size = CGSize(width: 120, height: 36)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.textColor = .white
        self.font = UIFont.boldSystemFont(ofSize: 18)
        self.textAlignment = .center
        
        self.layer.cornerRadius = frame.height / 2
        self.layer.masksToBounds = true
        self.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
    }
    
    convenience init(origin: CGPoint, color: UIColor)
    {
        self.init(frame: CGRect(x: origin.x, y:origin.y, width: CardViewLabel.size.width, height: CardViewLabel.size.height))
        self.backgroundColor = color
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
