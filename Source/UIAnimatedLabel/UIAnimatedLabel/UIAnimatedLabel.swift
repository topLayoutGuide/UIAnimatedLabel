//
//  UIAnimatedLabel.swift
//  UIAnimatedLabel
//
//  MIT License
//
//  Copyright (c) 2021 Ben Deckys
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

public class UIAnimatedLabel: UILabel {
    private enum Constants {
        static let easingRate = Float(3.0)
    }

    public enum Method {
        case easeInOut, easeIn, easeOut, linear
    }

    public enum Format {
        case zero, one, two, all

        var format: String {
            switch self {
            case .zero: return "%.0f"
            case .one: return "%.1f"
            case .two: return "%.2f"
            case .all: return "%f"
            }
        }
    }

    // MARK: - Private

    private var currentValue: Float {
        if progress >= duration { return to }
        return from + (update(t: Float(progress / duration)) * (to - from))
    }

    private var from: Float = 0
    private var to: Float = 0
    private var progress: TimeInterval = 0
    private var lastUpdatedTime: TimeInterval = 0
    private var duration: TimeInterval = 0
    private var displayLink: CADisplayLink?
    private var completion: (() -> Void)?

    // MARK: - Public

    public var format: Format = .zero
    public var method: Method = .easeInOut

    public func count(from: Float, to: Float, duration: TimeInterval = 10.0, _ completion: (() -> Void)? = nil) {
        self.completion = completion
        self.from = from
        self.to = to
        self.progress = 0.0
        self.duration = duration
        self.lastUpdatedTime = Date.timeIntervalSinceReferenceDate
        resetTimer()

        if duration == 0.0 {
            text = String(format: decimalPoints.format, to)
            completion?()
            return
        }

        addDisplayLink()
    }

    public func countFromCurrent(to: Float, duration: TimeInterval = 10.0, _ completion: (() -> Void)? = nil) {
        count(from: currentValue, to: to, duration: duration, completion)
    }

    public func stopAnimating() {
        resetTimer()
        progress = duration
    }

}

private extension UIAnimatedLabel {
    private func resetTimer() {
        displayLink?.invalidate()
        displayLink = nil
    }

    private func addDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(self.updateValue(timer:)))
        displayLink?.add(to: .main, forMode: .default)
        displayLink?.add(to: .main, forMode: .tracking)
    }

    private func update(t: Float) -> Float {
        switch countingMethod {
        case .linear:
            return updateLinear(t)
        case .easeIn:
            return updateEaseIn(t)
        case .easeInOut:
            return updateEaseInOut(t)
        case .easeOut:
            return updateEaseOut(t)
        }
    }

    private func updateLinear(_ t: Float) -> Float {
        t
    }

    private func updateEaseIn(_ t: Float) -> Float {
        powf(t, Constants.easingRate)
    }

    private func updateEaseInOut(_ t: Float) -> Float {
        var t = t
        t *= 2

        if t < 1 {
            return 0.5 * powf(t, Constants.easingRate)
        } else {
            return 0.5 * (2.0 - powf(2.0 - t, Constants.easingRate))
        }
    }

    private func updateEaseOut(_ t: Float) -> Float {
        1.0 - powf((1.0-t), Constants.easingRate)
    }

    @objc private func updateValue(timer: Timer) {
        let now: TimeInterval = Date.timeIntervalSinceReferenceDate
        progress += now - lastUpdatedTime
        lastUpdatedTime = now

        if progress >= duration {
            resetTimer()
            progress = duration
        }

        text = String(format: decimalPoints.format, currentValue)

        if progress == duration { completion?() }
    }
}
