//
//  GameViewController.swift
//  ModelViewer
//
//  Created by Ricardo on 8/2/14.
//  Copyright (c) 2014 RendonCepeda. All rights reserved.
//

import UIKit
import SceneKit

class GameViewController: UIViewController {
    @IBOutlet weak var sceneView: SCNView!

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.scene = SCNScene(named: "art.scnassets/mushroom");
    }
}
