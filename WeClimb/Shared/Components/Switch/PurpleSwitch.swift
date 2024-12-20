//
//  PurpleSwitch.swift
//  WeClimb
//
//  Created by 강유정 on 12/20/24.
//

import UIKit

public final class PurpleSwitch: UISwitch {
    
    private enum PurpleSwitchNS {
        static let activeColor = UIColor(red: 160/255, green: 83/255, blue: 233/255, alpha: 1)
        static let disabledColor = UIColor(red: 223/255, green: 224/255, blue: 226/255, alpha: 1)
    }
    
    public init(isEnabled: Bool = false) {
        super.init(frame: .zero)
        
        self.onTintColor = PurpleSwitchNS.activeColor
        self.subviews.first?.subviews.first?.backgroundColor = PurpleSwitchNS.disabledColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public var isOn: Bool {
        didSet {
            if isOn {
                self.onTintColor = PurpleSwitchNS.activeColor
                self.subviews.first?.subviews.first?.backgroundColor = PurpleSwitchNS.activeColor
            } else {
                self.onTintColor = PurpleSwitchNS.disabledColor
                self.subviews.first?.subviews.first?.backgroundColor = PurpleSwitchNS.disabledColor
            }
        }
    }
}
