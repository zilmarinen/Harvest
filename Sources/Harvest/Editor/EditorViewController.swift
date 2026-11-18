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
import MetalKit

public protocol EditorViewDataSource: NSViewController {}

public protocol EditorViewDelegate: NSViewController {}

public class EditorViewController: NSViewController {
    
    private let cursorOverlay = with(CursorOverlay()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var camera = Camera()
    
    private lazy var editor = with(MTKView(frame: .zero)) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.clearColor = .init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        $0.isPaused = false
        $0.enableSetNeedsDisplay = false
    }
    
    private let viewModel: ViewModel
    private weak var dataSource: EditorViewDataSource?
    private weak var delegate: EditorViewDelegate?
    
    private static let clearColor: MTLClearColor = {
        
        let color = NSColor.windowBackgroundColor.usingColorSpace(.deviceRGB) ?? .white
        
        return MTLClearColor(red: color.redComponent,
                             green: color.greenComponent,
                             blue: color.blueComponent,
                             alpha: color.alphaComponent)
    }()
    
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
        
        let worldSpace = camera.worldPoint(fromView: screenSpace,
                                           viewSize: editor.frame.size)
        
        viewModel.update(hitTest: worldSpace)
    }
}

// MARK: Scene

public extension EditorViewController {
    
    // MARK: Grid
    
    var showGrid: Bool {
        
        viewModel.showGrid
    }
    
    func update(showGrid value: Bool) {
        
        viewModel.update(showGrid: value)
    }
    
    // MARK: Zoom Level
    
    var zoomLevel: ZoomLevel {
        
        viewModel.zoomLevel
    }
    
    func update(zoomLevel value: ZoomLevel) {
        
        viewModel.update(zoomLevel: value)
    }
}
