//
//  ViewController.swift
//  Example
//
//  Created by Ben Deckys on 2021/10/15.
//

import UIKit
import UIAnimatedLabel

class ViewController: UIViewController {

    @IBOutlet private weak var animatedLabel: UIAnimatedLabel! {
        didSet {
            animatedLabel.format = .zero
            animatedLabel.method = .easeInOut
        }
    }

    @IBAction private func count(sender: Any? = nil) {
        animatedLabel.countFromCurrent(to: 1000, duration: 10.0)
    }

    @IBAction private func stop(sender: Any? = nil) {
        animatedLabel.stopAnimating()
    }
}

