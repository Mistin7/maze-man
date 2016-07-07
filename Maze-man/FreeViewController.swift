//
//  FreeViewController.swift
//  Maze-man
//
//  Created by Chekunin Alexey on 08.03.16.
//  Copyright © 2016 Chekunin Alexey. All rights reserved.
//

import UIKit
import SpriteKit

class FreeViewController: UIViewController {
    override func loadView() {
        self.view = SKView(frame: UIScreen.mainScreen().applicationFrame)
        //self.view = SKView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 320, height: 640)))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let skView = self.view as! SKView
        var size = skView.bounds.size
        size.width *= 2
        size.height *= 2
        let scene = Free(size: size)
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.showsPhysics = false
        scene.scaleMode = .AspectFill
        skView.presentScene(scene)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}