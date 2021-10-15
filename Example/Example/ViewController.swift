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
            animatedLabel.decimalPoints = .zero
        }
    }

    @IBAction private func count(sender: Any? = nil) {
        animatedLabel.count(from: 0, to: 100, duration: 10.0)
    }

    @IBAction private func stop(sender: Any? = nil) {
        animatedLabel.stopAnimating()
    }
}

