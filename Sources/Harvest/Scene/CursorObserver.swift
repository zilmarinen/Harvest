//
//  CursorObserver.swift
//
//  Created by Zack Brown on 03/10/2021.
//

import Foundation
import Meadow

extension Scene2D {
    
    public enum CursorState: MachineState {
        
        public enum EventType {
            
            case left
            case right
        }
        
        case down(position: GridBounds, eventType: EventType)
        case tracking(position: GridBounds, eventType: EventType)
        case up(position: GridBounds, eventType: EventType)
        case idle(position: Coordinate)
        
        public func shouldTransition(to newState: CursorState) -> Should<CursorState> {
        
            switch newState {
                
            case .up(let position, _):
                
                return .redirect(.idle(position: position.end))
                
            case .down(let position, let eventType):
                
                return .redirect(.tracking(position: position, eventType: eventType))
                
            default: return .continue
            }
        }
    }
    
    public class CursorObserver: StateObserver<CursorState> {
        
        public static let cursorEvent = Notification.Name.init("Scene2D.CursorState.EventNotification")
        
        public struct CursorEvent {
            
            public let position: GridBounds
            public let eventType: CursorState.EventType
        }
        
        public var tracksIdleEvents: Bool = false
        
        public override func stateDidChange(from: CursorState?, to: CursorState) {
            
            switch to {
                
            case .up(let position, let eventType):
                
                DispatchQueue.main.async {
                    
                    let event = CursorEvent(position: position, eventType: eventType)
                    
                    NotificationCenter.default.post(name: CursorObserver.cursorEvent, object: event)
                }
                
            default: break
            }
        }
    }
}
