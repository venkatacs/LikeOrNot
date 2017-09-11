//
//  ImageCard.swift
//  LikeOrNot
//
//  Created by surya on 9/5/17.
//  Copyright © 2017 surya. All rights reserved.
//

import UIKit

class ImageCard: CardView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //Image
        
        let imageView = UIImageView (image: UIImage(named: "default_image"))
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor(red: 70/255, green: 80/255, blue: 80/255, alpha: 1.0)
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        
        imageView.frame = CGRect(x: 12, y: 12, width: self.frame.width - 24, height: self.frame.height - 83)
        self.addSubview(imageView)
        
        
        // Text Boxes
        
        let textBox1 = UITextView()
        textBox1.text = "Name_My_Name"
        textBox1.textColor = UIColor.white
        textBox1.backgroundColor = UIColor.lightGray
        textBox1.layer.cornerRadius = 12
        textBox1.layer.masksToBounds = true
        
        textBox1.frame = CGRect(x: 12, y: imageView.frame.maxY+15, width: 200, height: 24)
        self.addSubview(textBox1)
        
        let textBox2 = UITextView()
        textBox2.text = "Gender"
        textBox2.textColor = UIColor.white
        textBox2.backgroundColor = UIColor.lightGray
        textBox2.layer.cornerRadius = 12
        textBox2.layer.masksToBounds = true
        
        textBox2.frame = CGRect(x: 12, y: imageView.frame.maxY+40, width: 120, height: 24)
        self.addSubview(textBox2)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
