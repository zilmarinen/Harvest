//
//  EditorViewController.swift
//  Harvest
//
//  Created by Zack Brown on 30/10/2026.
//

import Alluvium
import AppKit
import Deltille
import Euclid
import SpriteKit

public protocol EditorViewDataSource: NSViewController {}

public protocol EditorViewDelegate: NSViewController {}

public class EditorViewController: NSViewController {
    
    private let cursorOverlay = with(CursorOverlay()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let camera = Camera()
    private let cursor = with(Cursor(circleOfRadius: 3.5)) {
        
        $0.strokeColor = .systemPink
        $0.fillColor = .white
        $0.lineWidth = 2.0
    }
    
    private lazy var scene = with(EditorScene(viewModel.lattice)) {
        
        $0.delegate = self
        $0.backgroundColor = .windowBackgroundColor
        $0.scaleMode = .resizeFill
        $0.camera = camera
        
        $0.addChild(camera)
        $0.addChild(cursor)
    }
    
    private lazy var editor = with(SKView(frame: .zero)) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.presentScene(scene)
    }
    
    private let viewModel: ViewModel
    private weak var dataSource: EditorViewDataSource?
    private weak var delegate: EditorViewDelegate?
    
    public init(dataSource: EditorViewDataSource,
                delegate: EditorViewDelegate) {
        
        self.viewModel = .init()
        self.dataSource = dataSource
        self.delegate = delegate
        
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override public func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.addSubview(editor)
        
        view.addSubview(cursorOverlay)
        
        NSLayoutConstraint.activate([
            
            editor.topAnchor.constraint(equalTo: view.topAnchor),
            editor.leftAnchor.constraint(equalTo: view.leftAnchor),
            editor.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            editor.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            cursorOverlay.leadingAnchor.constraint(greaterThanOrEqualTo: editor.leadingAnchor),
            cursorOverlay.trailingAnchor.constraint(equalTo: editor.trailingAnchor,
                                                    constant: -.padding),
            cursorOverlay.topAnchor.constraint(greaterThanOrEqualTo: editor.topAnchor),
            cursorOverlay.bottomAnchor.constraint(equalTo: editor.bottomAnchor,
                                                  constant: -.padding)
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
    
    override public func mouseMoved(with event: NSEvent) {
        
        super.mouseMoved(with: event)
        
        let screenSpace = editor.convert(event.locationInWindow,
                                         from: nil)
        
        let worldSpace = scene.convertPoint(fromView: screenSpace)
        
        viewModel.update(hitTest: worldSpace)
        
        let position = viewModel.hitTest.triangle.vertex.vector(scene.lattice)
        
        cursor.position = .init(x: position.x,
                                y: position.z)
        
        cursorOverlay.hitTest = viewModel.hitTest
    }
}

// MARK: Scene Delegate

extension EditorViewController: @MainActor SKSceneDelegate {
    
    public func didFinishUpdate(for _: SKScene) {
        
        scene.clean()
    }
}
