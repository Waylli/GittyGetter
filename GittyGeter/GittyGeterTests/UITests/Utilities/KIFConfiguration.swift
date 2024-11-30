//
//  KIFConfiguration.swift
//  GittyGeterTests
//
//  Created by Petar Perkovski on 30/11/2024.
//

import Quick
import KIF

class KIFConfiguration: QuickConfiguration {

    class KIFConfiguration: QuickConfiguration {

        class func enableAccessibilityBeforeSpecClassSetup() {
            KIFEnableAccessibility()
        }

        override class func configure(_ configuration: QCKConfiguration!) {
            enableAccessibilityBeforeSpecClassSetup()
        }

    }
}
