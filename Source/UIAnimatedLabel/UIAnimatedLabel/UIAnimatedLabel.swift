//
//  UIAnimatedLabel.swift
//  UIAnimatedLabel
//
//  Created by Ben Deckys on 2021/10/15.
//

import UIKit

public class UIAnimatedLabel: UILabel {
    private enum Constants {
        static let easingRate = Float(3.0)
    }

    public enum CountingMethod {
        case easeInOut, easeIn, easeOut, linear
    }

    public enum DecimalPoints {
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
        if progress >= totalTime { return destinationValue }
        return startingValue + (update(t: Float(progress / totalTime)) * (destinationValue - startingValue))
    }

    private var startingValue: Float = 0
    private var destinationValue: Float = 0
    private var progress: TimeInterval = 0
    private var lastUpdate: TimeInterval = 0
    private var totalTime: TimeInterval = 0
    private var timer: CADisplayLink?
    private var completion: (() -> Void)?

    // MARK: - Public

    public var decimalPoints: DecimalPoints = .zero
    public var countingMethod: CountingMethod = .easeInOut

    public func count(from: Float, to: Float, duration: TimeInterval = 10.0, _ completion: (() -> Void)? = nil) {
        self.completion = completion
        startingValue = from
        destinationValue = to
        resetTimer()

        if duration == 0.0 {
            text = String(format: decimalPoints.format, to)
            completion?()
            return
        }

        progress = 0.0
        totalTime = duration
        lastUpdate = Date.timeIntervalSinceReferenceDate
        addDisplayLink()
    }

    public func stopAnimating() {
        resetTimer()
        progress = totalTime
    }

}

private extension UIAnimatedLabel {
    private func resetTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func addDisplayLink() {
        timer = CADisplayLink(target: self, selector: #selector(self.updateValue(timer:)))
        timer?.add(to: .main, forMode: .default)
        timer?.add(to: .main, forMode: .tracking)
    }

    private func update(t: Float) -> Float {
        var t = t

        switch countingMethod {
        case .linear:
            return t
        case .easeIn:
            return powf(t, Constants.easingRate)
        case .easeInOut:
            var sign: Float = 1
            t *= 2
            if Int(Constants.easingRate) % 2 == 0 { sign = -1 }
            return t < 1 ? 0.5 * powf(t, Constants.easingRate) : (sign * 0.5) * (powf(t - 2, Constants.easingRate) + sign * 2)
        case .easeOut:
            return 1.0 - powf((1.0-t), Constants.easingRate)
        }
    }

    @objc private func updateValue(timer: Timer) {
        let now: TimeInterval = Date.timeIntervalSinceReferenceDate
        progress += now - lastUpdate
        lastUpdate = now

        if progress >= totalTime {
            self.timer?.invalidate()
            self.timer = nil
            progress = totalTime
        }

        text = String(format: decimalPoints.format, currentValue)

        if progress == totalTime { completion?() }
    }
}
