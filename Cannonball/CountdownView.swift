//
// Copyright (C) 2014 Twitter, Inc. and other contributors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//         http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import UIKit
import QuartzCore

// Custom protocol for classes to implement the countdown.
protocol CountdownViewDelegate: class {

    func countdownView(countdown: CountdownView, didCountdownTo second: Int)

}

class CountdownView : UIView {

    let secondsLabel: UILabel

    let backgroundCircle: CAShapeLayer

    let foregroundCircle: CAShapeLayer

    weak var delegate: CountdownViewDelegate?

    var countdownTime: Int

    private var secondsRemaining: Double {
        didSet {
            self.progress = secondsRemaining / Double(countdownTime)

            let wholeSeconds = Int(ceil(secondsRemaining))
            secondsLabel.text = String(wholeSeconds)

            if wholeSeconds <= 10 {
                backgroundCircle.strokeColor = UIColor.cannonballRedLightColor().CGColor
                foregroundCircle.strokeColor = UIColor.cannonballRedColor().CGColor
                secondsLabel.textColor = UIColor.cannonballRedColor()
            }

            if wholeSeconds % 5 == 0 {
                delegate?.countdownView(self, didCountdownTo: Int(wholeSeconds))
            }
        }
    }

    private var displayLink: CADisplayLink?

    func start() {
        self.secondsRemaining = Double(countdownTime)

        self.displayLink?.invalidate()
        self.displayLink = UIScreen.mainScreen().displayLinkWithTarget(self, selector: Selector("tick"))
        self.displayLink!.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
    }

    func stop() {
        self.displayLink?.invalidate()
    }

    // [1, 0]
    private var progress: Double = 1 {
        didSet {
            // Update remaining time circle and label.
            foregroundCircle.strokeEnd = (CGFloat) (self.progress)
        }
    }

    func tick() {
        self.secondsRemaining -= self.displayLink!.duration
    }

    let textPadding: CGFloat = 5

    required init(frame aRect: CGRect, countdownTime time: Int) {
        countdownTime = time
        secondsRemaining = Double(countdownTime)

        secondsLabel = UILabel(frame: CGRect(x: textPadding, y: textPadding, width: aRect.size.width - 2 * textPadding, height: aRect.size.height - 2 * textPadding))
        backgroundCircle = CAShapeLayer()
        foregroundCircle = CAShapeLayer()
        super.init(frame: aRect)

        // Define the remaining time label.
        secondsLabel.text = String(countdownTime)
        secondsLabel.font = UIFont(name: "Avenir", size: 16)
        secondsLabel.textColor = UIColor.cannonballGreenColor()
        secondsLabel.textAlignment = NSTextAlignment.Center

        // Define the path for the circle strokes.
        let arcCenter = CGPoint(x: self.bounds.width / 2, y: self.bounds.width / 2)
        let radius: CGFloat = self.bounds.width / 2
        let startAngle = CGFloat(-0.5 * M_PI)
        let endAngle = CGFloat(1.5 * M_PI)
        let path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)

        // Define the background circle.
        backgroundCircle.path = path.CGPath
        backgroundCircle.fillColor = UIColor.clearColor().CGColor
        backgroundCircle.strokeColor = UIColor.cannonballGreenLightColor().CGColor
        backgroundCircle.strokeStart = 0
        backgroundCircle.strokeEnd = 1
        backgroundCircle.lineWidth = 2

        // Define the foreground circle indicating elapsing time.
        foregroundCircle.path = path.CGPath
        foregroundCircle.fillColor = UIColor.clearColor().CGColor
        foregroundCircle.strokeColor = UIColor.cannonballGreenColor().CGColor
        foregroundCircle.strokeStart = 0
        foregroundCircle.strokeEnd = 1
        foregroundCircle.lineWidth = 2

        // Add the circles and label to the main view.
        self.layer.addSublayer(backgroundCircle)
        self.layer.addSublayer(foregroundCircle)
        self.addSubview(secondsLabel)
    }

    override convenience init(frame aRect: CGRect) {
        self.init(frame: aRect, countdownTime: 0)
    }

    required init(coder decoder: NSCoder) {
        fatalError("Nibs not supported in this UIView subclass")
    }

}
