//
//  CursorOverlay.swift
//  Harvest
//
//  Created by Zack Brown on 09/11/2026.
//

import Alluvium
import AppKit
import Deltille

internal class CursorOverlay: NSControl {
    
    private lazy var glass = with(NSGlassEffectView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.style = .regular
        $0.contentView = contentView
    }
    
    private lazy var contentView = with(NSView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var stackView = with(NSStackView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.orientation = .horizontal
        $0.alignment = .centerY
        $0.spacing = .spacing
        $0.addArrangedSubview(button)
        $0.addArrangedSubview(separator)
        $0.addArrangedSubview(xLabel)
        $0.addArrangedSubview(yLabel)
        $0.addArrangedSubview(zLabel)
    }
    
    private lazy var separator = with(NSBox()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.boxType = .separator
    }
    
    private lazy var button = with(NSButton()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setButtonType(.momentaryPushIn)
        $0.isBordered = true
        $0.target = self
        $0.action = #selector(button(_:))
        $0.bezelColor = cursorMode.color
        $0.title = cursorMode.id
    }
    
    private lazy var xLabel = with(NSTextField()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .monospacedDigitSystemFont(ofSize: NSFont.systemFontSize,
                                             weight: .regular)
        $0.textColor = .lightGray
        $0.isEditable = false
        $0.isBordered = false
        $0.maximumNumberOfLines = 1
        $0.backgroundColor = .clear
        $0.alignment = .center
    }
    
    private lazy var yLabel = with(NSTextField()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .monospacedDigitSystemFont(ofSize: NSFont.systemFontSize,
                                             weight: .regular)
        $0.textColor = .lightGray
        $0.isEditable = false
        $0.isBordered = false
        $0.maximumNumberOfLines = 1
        $0.backgroundColor = .clear
        $0.alignment = .center
    }
    
    private lazy var zLabel = with(NSTextField()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .monospacedDigitSystemFont(ofSize: NSFont.systemFontSize,
                                             weight: .regular)
        $0.textColor = .lightGray
        $0.isEditable = false
        $0.isBordered = false
        $0.maximumNumberOfLines = 1
        $0.backgroundColor = .clear
        $0.alignment = .center
    }
    
    internal var hitTest: HitTest = .init(.zero) {
        
        didSet {
            
            update()
        }
    }
    
    internal var cursorMode: CursorMode = .tile {
        
        didSet {
            
            update()
            
            button.bezelColor = cursorMode.color
            button.title = cursorMode.id
        }
    }
    
    internal init() {
        
        super.init(frame: .zero)
        
        addSubview(glass)
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            glass.topAnchor.constraint(equalTo: topAnchor),
            glass.leftAnchor.constraint(equalTo: leftAnchor),
            glass.bottomAnchor.constraint(equalTo: bottomAnchor),
            glass.rightAnchor.constraint(equalTo: rightAnchor),
            
            contentView.topAnchor.constraint(equalTo: glass.topAnchor),
            contentView.leftAnchor.constraint(equalTo: glass.leftAnchor),
            contentView.bottomAnchor.constraint(equalTo: glass.bottomAnchor),
            contentView.rightAnchor.constraint(equalTo: glass.rightAnchor),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                           constant: .padding),
            stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor,
                                            constant: .padding),
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            button.widthAnchor.constraint(equalToConstant: .buttonSize),
            button.heightAnchor.constraint(equalToConstant: .buttonSize),
            
            separator.widthAnchor.constraint(equalToConstant: 1.0),
            separator.topAnchor.constraint(equalTo: stackView.topAnchor),
            separator.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),

            xLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: .labelSize),
            yLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: .labelSize),
            zLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: .labelSize),
        ])
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

private extension CursorOverlay {
    
    @objc
    func button(_ sender: NSButton) {
        
        cursorMode = cursorMode == .tile ? .vertex : .tile
    }
    
    func update() {
        
        switch cursorMode {
            
        case .tile:
            
            xLabel.stringValue = "\(hitTest.triangle.x)"
            yLabel.stringValue = "\(hitTest.triangle.y)"
            zLabel.stringValue = "\(hitTest.triangle.z)"
            
        case .vertex:
            
            xLabel.stringValue = "\(hitTest.vertex.x)"
            yLabel.stringValue = "\(hitTest.vertex.y)"
            zLabel.stringValue = "\(hitTest.vertex.z)"
        }
    }
}
