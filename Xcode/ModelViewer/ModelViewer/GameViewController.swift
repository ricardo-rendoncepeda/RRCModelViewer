//
//  GameViewController.swift
//  ModelViewer
//
//  Created by Ricardo on 8/2/14.
//  Copyright (c) 2014 RendonCepeda. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    @IBOutlet weak var sceneView: SCNView!
    
    let model = "mushroom"

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        sceneView.scene = SCNScene(named: "art.scnassets/"+model);
    }
}
