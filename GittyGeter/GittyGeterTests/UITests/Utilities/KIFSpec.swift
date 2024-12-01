//
//  KIFSpec.swift
//  GittyGeterTests
//
//  Created by Petar Perkovski on 30/11/2024.
//

import Quick
import Nimble
import KIF

@testable import GittyGeter

public func tester(file: String = #file, _ line: Int = #line) -> KIFUITestActor {
    return KIFUITestActor(inFile: file, atLine: line, delegate: KIFSpec.getCurrentKIFActorDelegate())
}

public func viewTester(file: String = #file, _ line: Int = #line) -> KIFUIViewTestActor {
    return KIFUIViewTestActor(inFile: file, atLine: line, delegate: KIFSpec.getCurrentKIFActorDelegate())
}

public func system(file: String = #file, _ line: Int = #line) -> KIFSystemTestActor {
    return KIFSystemTestActor(inFile: file, atLine: line, delegate: KIFSpec.getCurrentKIFActorDelegate())
}

class KIFSpec: QuickSpec {
    private static var currentKIFActorDelegate: KIFTestActorDelegate?

    fileprivate class Prepare: KIFSpec {
        override var name: String {
            return "prepare KIF spec"
        }
    }

    /**
     returns current QuickSpec as KIFTestActorDelegate
     */
    fileprivate class func getCurrentKIFActorDelegate() -> KIFTestActorDelegate {
        let delegate = KIFSpec.currentKIFActorDelegate
        precondition(delegate != nil, "Test actor delegate should be configured. " +
                     "Did you attempt to use a KIFTestActor outside of a test?")
        return delegate!
    }

    /**
     if test failure happens while in setUp blame prepare not test
     */
    override public class func setUp() {
        super.setUp()
        let dummySpec = Prepare()
        currentKIFActorDelegate = dummySpec
    }

    /**
     reset delegate to avoid blaming wrong test
     */
    override public class func tearDown() {
        currentKIFActorDelegate = nil
        _ = Prepare()
        super.tearDown()
    }

    /**
     prepare KIFTestActorDelegate to be this Quick spec
     */
    override public func setUp() {
        super.setUp()
        continueAfterFailure = false
        KIFSpec.currentKIFActorDelegate = self
    }

    override public func tearDown() {
        super.tearDown()
    }

    override open func fail(with exception: NSException!, stopTest stop: Bool) {
        if let userInfo = exception.userInfo {
            Nimble.fail(exception.description,
                        file: userInfo["FilenameKey"] as! String,
                        line: userInfo["LineNumberKey"] as! UInt)
        } else {
            Nimble.fail(exception.description)
        }
    }
}

import SwiftUI
extension KIFSpec {

    static
    func presentView<T: View>(view: T) -> (view: T, rootView: UIViewController) {
        let rootView = try! UIApplication.getVisibleViewController()
        rootView.present(view.toViewController(), animated: false)
        tester().waitForAnimationsToFinish()
        return (view, rootView)
    }

    static
    func cleanUp(rootView: UIViewController) {
        rootView.dismiss(animated: false)
        tester().waitForAnimationsToFinish()
    }

    static
    func assertViewExists(withAccessibilityLabel label: String, description: String? = nil) {
        let view = tester().waitForView(withAccessibilityLabel: label)
        expect(view).toNot(beNil(), description: description ?? "View with accessibility label '\(label)' should exist.")
    }

}
