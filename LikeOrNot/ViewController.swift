//
//  ViewController.swift
//  LikeOrNot
//
//  Created by surya on 9/5/17.
//  Copyright © 2017 surya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    var cards = [ImageCard] ()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 140/255, green: 160/255, blue: 20/255, alpha:1.0)
        //dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        dynamicAnimator = UIDynamicAnimator (referenceView: self.view)
        // 1. setup screen
        setupFakeUI()
        
        for _ in 1...20 {
            let card = ImageCard(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 60, height: self.view.frame.height * 0.6))
            cards.append(card)
        }
        // show first 4 cards
        layoutCards()
    }
    
    //scale and alpha of successive cards visible to the user
    let cardAttributes: [(downscale: CGFloat, alpha: CGFloat)] = [(1,1),(0.92,0.8),(0.84,0.6),(0.76,0.4)]
    let cardInterItemSpacing: CGFloat = 15
    
    func layoutCards()
    {
        let firstCard = cards[0]
        self.view.addSubview(firstCard)
        firstCard.layer.zPosition = CGFloat(cards.count)
        firstCard.center = self.view.center
        firstCard.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleCardPan)))
        
        for i in 1...3 {
            if i > (cards.count - 1) { continue }
            
            let card = cards[i]
            
            card.layer.zPosition = CGFloat(cards.count - i)
            
            let downscale = cardAttributes[i].downscale
            let alpha = cardAttributes[i].alpha
            card.transform = CGAffineTransform(scaleX: downscale, y: downscale)
            card.alpha = alpha
            
            
            card.center.x = self.view.center.x
            card.frame.origin.y = cards[0].frame.origin.y - (CGFloat(i)*cardInterItemSpacing)
            
            if i == 3 {
                card.frame.origin.y += 1.5
            }
            self.view.addSubview(card)
        }
        self.view.bringSubview(toFront: cards[0])
    }
    
    
    
    
    func showNextCard() {
        let animationDuration: TimeInterval = 0.2
        
        for i in 1...3 {
            if i > (cards.count - 1) { continue }
            let card = cards[i]
            let newDownscale = cardAttributes[i-1].downscale
            let newAlpha = cardAttributes[i-1].alpha
            
            UIView.animate(withDuration: animationDuration, delay: (TimeInterval(i-1)*(animationDuration/2)), options: [], animations: {
                card.transform = CGAffineTransform(scaleX: newDownscale, y: newDownscale)
                card.alpha = newAlpha
                
                if i == 1 {
                    card.center = self.view.center
                }
                else{
                    card.center.x = self.view.center.x
                    card.frame.origin.y = self.cards[1].frame.origin.y - (CGFloat(i-1) * self.cardInterItemSpacing)
                }
                
            }, completion: {(_) in
                if i == 1 {
                    card.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handleCardPan)))
                }
            })
        }
        
        
        //add new card to the back of deck
        if 4 > (cards.count - 1) {
            if cards.count != 1 {
                self.view.bringSubview(toFront: cards[1])
            }
            return
        }
        let newCard = cards[4]
        newCard.layer.zPosition = CGFloat(cards.count - 4)
        let downscale = cardAttributes[3].downscale
        let alpha = cardAttributes[3].alpha
        
        
        //new card start
        newCard.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        newCard.alpha = 0
        newCard.center.x = self.view.center.x
        newCard.frame.origin.y = cards[1].frame.origin.y - (4*cardInterItemSpacing)
        self.view.addSubview(newCard)
        
        //new card end animate
        UIView.animate(withDuration: animationDuration, delay: (3*(animationDuration/2)), options: [], animations: {
            newCard.transform = CGAffineTransform(scaleX: downscale, y: downscale)
            newCard.alpha = alpha
            newCard.center.x = self.view.center.x
            newCard.frame.origin.y = self.cards[1].frame.origin.y - (3*self.cardInterItemSpacing) + 1.5
        }, completion: {
            (_) in
        })
        self.view.bringSubview(toFront: self.cards[1])
    }
    
    func removOldFrontCard(){
        cards[0].removeFromSuperview()
        cards.remove(at: 0)
    }
    
    var dynamicAnimator: UIDynamicAnimator!
    var cardAttachmentBehavior: UIAttachmentBehavior!
    
    
    func handleCardPan(sender: UIPanGestureRecognizer) {
        
        if cardIsHiding {
            return
        }
        
        let optionLength: CGFloat = 60
        
        let requiredOffsetFromCenter: CGFloat = 15
        
        let panLocationInView = sender.location(in: view)
        let panLocationInCard = sender.location(in: cards[0])
        
        switch sender.state {
        case .began:
            dynamicAnimator.removeAllBehaviors()
            let offset = UIOffsetMake(panLocationInCard.x - cards[0].bounds.midX, panLocationInCard.y - cards[0].bounds.midY);
            // card is attached to center
            cardAttachmentBehavior = UIAttachmentBehavior(item: cards[0], offsetFromCenter: offset, attachedToAnchor: panLocationInView)
            dynamicAnimator.addBehavior(cardAttachmentBehavior)
        
        case .changed:
            cardAttachmentBehavior.anchorPoint = panLocationInView
            if cards[0].center.x > (self.view.center.x + requiredOffsetFromCenter){
                if cards[0].center.y < (self.view.center.y - optionLength){
                    cards[0].showOptionLabel(option: .like1)
                    
                }
                else if cards[0].center.y > (self.view.center.y + optionLength)
                {
                    cards[0].showOptionLabel(option: .like3)
                }
                else{
                    cards[0].showOptionLabel(option: .like2)
                }
            } else if cards[0].center.x < (self.view.center.x - requiredOffsetFromCenter) {
                if cards[0].center.y < (self.view.center.y - optionLength) {
                    cards[0].showOptionLabel(option: .dislike1)
                } else if cards[0].center.y > (self.view.center.y + optionLength) {
                    cards[0].showOptionLabel(option: .dislike3)
                } else {
                    cards[0].showOptionLabel(option: .dislike2)
                }
            } else {
                cards[0].hideOptionLabel()
            }
        case .ended:
            dynamicAnimator.removeAllBehaviors()
            
            if !(cards[0].center.x > (self.view.center.x + requiredOffsetFromCenter) || cards[0].center.x < (self.view.center.x - requiredOffsetFromCenter)) {
                let snapBehavior  = UISnapBehavior(item: cards[0], snapTo: self.view.center)
                dynamicAnimator.addBehavior(snapBehavior)
            }else {
                let velocity = sender.velocity(in: self.view)
                let pushBehavior = UIPushBehavior(items: [cards[0]], mode: .instantaneous)
                pushBehavior.pushDirection = CGVector(dx: velocity.x/10, dy: velocity.y/10)
                pushBehavior.magnitude = 175
                dynamicAnimator.addBehavior(pushBehavior)
                
                //spin
                
                var angular = CGFloat.pi / 2
                
                let currentAngle : Double = atan2(Double(cards[0].transform.b), Double(cards[0].transform.a))
                
                if currentAngle > 0 {
                    angular = angular * 1
                } else {
                    angular = angular * -1
                }
                let itemBehavior = UIDynamicItemBehavior(items: [cards[0]])
                itemBehavior.friction = 0.2
                itemBehavior.allowsRotation = true
                itemBehavior.addAngularVelocity(CGFloat(angular), for: cards[0])
                dynamicAnimator.addBehavior(itemBehavior)
                
                showNextCard()
                hideFrontCard()
                

            }
            
        default:
            break
        }
    }
    
    var cardIsHiding = false
    
    func hideFrontCard() {
        if #available(iOS 10.0, *) {
            var cardRemoverTimer: Timer? = nil
            cardRemoverTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: {
            [weak self] (_) in
                //gaurd self !=nil else {return}
                if !(self!.view.bounds.contains(self!.cards[0].center)){
                    cardRemoverTimer!.invalidate()
                    self?.cardIsHiding = true
                    UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
                    self?.cards[0].alpha = 0.0
                    }, completion: { (_) in
                        self?.removOldFrontCard()
                        self?.cardIsHiding = false
                    
                    })
                }
            })
        } else {
            UIView.animate(withDuration: 0.2, delay: 1.5, options: [.curveEaseIn], animations: {
                self.cards[0].alpha = 0.0
            }, completion: { (_) in
                self.removOldFrontCard()
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupFakeUI()
    {
      
        
        // Title
        let titleLabel = UILabel()
        titleLabel.text = "Like or No?"
        titleLabel.numberOfLines = 1
        titleLabel.font = UIFont(name: "AvenirNext-Bold", size: 19)
        titleLabel.textColor = UIColor(red: 90/255, green: 100/255, blue: 200/255, alpha: 1.0)
        titleLabel.textAlignment = .center
        titleLabel.frame = CGRect(x: (self.view.frame.width/2) - 90, y: 17, width: 180, height: 60)
        self.view.addSubview(titleLabel)
        
        // Reaction
        let reactLabel = UILabel()
        reactLabel.text = "What do you think?"
        reactLabel.font = UIFont(name: "AvenirNextCondensed-Heavy", size: 28)
        reactLabel.textColor = UIColor(red: 60/255, green: 80/255, blue: 150/255, alpha: 1.0)
        reactLabel.textAlignment = .center
        reactLabel.frame = CGRect(x: (self.view.frame.width/2)-80, y: self.view.frame.height - 70, width: 240, height: 50)
        reactLabel.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height - 70)
        self.view.addSubview(reactLabel)
        
    }
}

