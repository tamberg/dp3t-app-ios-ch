/*
 * Copyright (c) 2020 Ubique Innovation AG <https://www.ubique.ch>
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 *
 * SPDX-License-Identifier: MPL-2.0
 */

import UIKit

class NSInformViewController: NSInformStepViewController {
    static func present(from rootViewController: UIViewController, prefill: String? = nil) {
        let informVC: UIViewController

        informVC = NSSendViewController(prefill: prefill)

        let navCon = NSNavigationController(rootViewController: informVC)

        if UIDevice.current.isSmallScreenPhone {
            navCon.modalPresentationStyle = .fullScreen
        }

        rootViewController.present(navCon, animated: true, completion: nil)
    }
}
