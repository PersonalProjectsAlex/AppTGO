//
//  ActionDescriptor.swift
//  Tugo
//
//  Created by Alex on 22/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation
import UIKit


enum ActionDescriptor {
    case edit, delete
    
    func title(forDisplayMode displayMode: ButtonDisplayMode) -> String? {
        guard displayMode != .imageOnly else { return nil }
        
        switch self {
        
        case .edit: return "Editar"
        case .delete: return "Eliminar"
        }
    }
    
    func image(forStyle style: ButtonStyle, displayMode: ButtonDisplayMode) -> UIImage? {
        guard displayMode != .titleOnly else { return nil }
        
        let name: String
        switch self {
        
        case .edit: name = "trash-circle"
        case .delete: name = "trash-circle"
        }
        
        return UIImage(named: style == .backgroundColor ? name : name + "-circle")
    }
    
    var color: UIColor {
        switch self {
        case .edit: return #colorLiteral(red: 0, green: 0.4577052593, blue: 1, alpha: 1)
        case .delete: return #colorLiteral(red: 1, green: 0.2352941176, blue: 0.1882352941, alpha: 1)
        }
    }
}
enum ButtonDisplayMode {
    case titleAndImage, titleOnly, imageOnly
}

enum ButtonStyle {
    case backgroundColor, circular
}
