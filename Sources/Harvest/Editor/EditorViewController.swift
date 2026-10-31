//
//  EditorViewController.swift
//  Harvest
//
//  Created by Zack Brown on 30/10/2026.
//

import Alluvium
import AppKit
import SpriteKit

public protocol EditorViewDelegate: NSViewController {}

public class EditorViewController: NSViewController {
    
    internal let camera = Camera()
    internal let cursor = Cursor()
    
    internal lazy var scene = with(EditorScene()) {
        
        $0.scaleMode = .resizeFill
        $0.camera = camera
        
        $0.addChild(camera)
        $0.addChild(cursor)
    }
    
    internal lazy var editor = with(SKView(frame: .zero)) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.presentScene(scene)
    }
    
    private weak var delegate: EditorViewDelegate?
    
    public init(delegate: EditorViewDelegate) {
        
        self.delegate = delegate
        
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override public func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.addSubview(editor)
        
        NSLayoutConstraint.activate([
                    
            editor.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            editor.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            editor.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            editor.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
    
    override public func viewDidLayout() {
        
        super.viewDidLayout()
        
        editor.trackingAreas.forEach {
            
            editor.removeTrackingArea($0)
        }
        
        let trackingArea = NSTrackingArea(rect: editor.frame,
                                          options: [.activeInKeyWindow,
                                                    .mouseMoved],
                                          owner: self)
        
        editor.addTrackingArea(trackingArea)
    }
}
