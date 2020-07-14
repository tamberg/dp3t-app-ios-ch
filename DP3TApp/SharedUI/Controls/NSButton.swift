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

class NSButton: UBButton {
    enum Style {
        // bool fo
        case normal(UIColor)
        case uppercase(UIColor)
        case outlineUppercase(UIColor)
        case borderlessUppercase(UIColor)

        var textColor: UIColor {
            switch self {
            case .normal:
                return UIColor.white
            case .uppercase:
                return UIColor.white
            case let .outlineUppercase(c):
                return c
            case let .borderlessUppercase(c):
                return c
            }
        }

        var backgroundColor: UIColor {
            switch self {
            case let .normal(c):
                return c
            case let .uppercase(c):
                return c
            case .outlineUppercase:
                return .clear
            case .borderlessUppercase:
                return .clear
            }
        }

        var borderColor: UIColor {
            switch self {
            case let .outlineUppercase(c):
                return c
            default:
                return .clear
            }
        }

        var highlightedColor: UIColor {
            return UIColor.black.withAlphaComponent(0.15)
        }

        var isUppercase: Bool {
            switch self {
            case .uppercase:
                return true
            case .outlineUppercase:
                return true
            case .borderlessUppercase:
                return true
            default:
                return false
            }
        }
    }

    var style: Style {
        didSet {
            setTitleColor(style.textColor, for: .normal)
            backgroundColor = style.backgroundColor
            layer.borderColor = style.borderColor.cgColor
        }
    }

    // MARK: - Init

    init(title: String, style: Style = .normal(UIColor.ns_purple), customTextColor: UIColor? = nil) {
        self.style = style

        super.init()

        self.title = style.isUppercase ? title.uppercased() : title

        titleLabel?.font = NSLabelType.button.font
        setTitleColor(style.textColor, for: .normal)

        if let c = customTextColor {
            setTitleColor(c, for: .normal)
        }

        backgroundColor = style.backgroundColor
        highlightedBackgroundColor = style.highlightedColor

        layer.borderColor = style.borderColor.cgColor
        layer.borderWidth = 2

        highlightCornerRadius = 3
        layer.cornerRadius = 3
        contentEdgeInsets = UIEdgeInsets(top: NSPadding.medium, left: NSPadding.large, bottom: NSPadding.medium, right: NSPadding.large)

        titleLabel?.numberOfLines = 2

        snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(44.0)
        }
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? style.backgroundColor : UIColor.black.withAlphaComponent(0.15)
        }
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize

        if contentSize.height > 44.0 {
            contentSize.height = contentSize.height + NSPadding.medium
        }

        return contentSize
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
            titleLabel?.font = NSLabelType.button.font
        }
    }
}

extension NSButton {
    static func faqButton(color: UIColor) -> UIView {
        let faqButton = NSExternalLinkButton(style: .outlined(color: color))
        faqButton.title = "faq_button_title".ub_localized

        faqButton.touchUpCallback = {
            if let url = URL(string: "faq_button_url".ub_localized) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }

        let view = UIView()

        view.addSubview(faqButton)

        faqButton.snp.makeConstraints { make in
            make.top.bottom.centerX.equalToSuperview()
            make.right.equalToSuperview().inset(NSPadding.medium)
            make.left.equalToSuperview().inset(NSPadding.medium)
        }

        faqButton.accessibilityHint = "accessibility_faq_button_hint".ub_localized
        faqButton.accessibilityTraits = [.button, .header]
        return view
    }
}
