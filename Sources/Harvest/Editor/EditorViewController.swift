//
//  EditorViewController.swift
//  Harvest
//
//  Created by Zack Brown on 30/10/2026.
//

import Alluvium
import AppKit
import Bivouac
import Deltille
import Euclid
import Lattice
import MetalKit
import simd

public protocol EditorViewDataSource: NSViewController {}

public protocol EditorViewDelegate: NSViewController {}

public class EditorViewController: NSViewController {
    
    private let cursorOverlay = with(CursorOverlay()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var editor = with(EditorView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private weak var dataSource: EditorViewDataSource?
    private weak var delegate: EditorViewDelegate?
    
    public init(dataSource: EditorViewDataSource,
                delegate: EditorViewDelegate) {
        
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
        
        let point = editor.convert(event.locationInWindow,
                                   from: nil)
        
        cursorOverlay.hitTest = editor.hit(point)
        editor.hit = editor.hit(point)
    }
}

public extension EditorViewController {
    
    // MARK: Grid
    
    var showGrid: Bool {
        
        editor.showGrid
    }
    
    func update(showGrid value: Bool) {
        
        editor.update(showGrid: value)
    }
    
    // MARK: Zoom Level
    
    var zoomLevel: ZoomLevel {
        
        editor.zoomLevel
    }
    
    func update(zoomLevel value: ZoomLevel) {
        
        editor.update(zoomLevel: value)
    }
}
