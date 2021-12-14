import UIKit
import AutomatticAbout
import SafariServices

class SimplenoteAboutScreenConfiguration: AboutScreenConfiguration {
    var sections: [AboutScreenSection] {
        [
            [
                AboutItem(title: Titles.rateUs, action: { [weak self] context in
                    self?.present(url: Links.rateUs, from: context.viewController)
                }),
                AboutItem(title: Titles.twitter, cellStyle: .value1, action: { [weak self] context in
                    self?.present(url: Links.twitter, from: context.viewController)
                }),
                AboutItem(title: Titles.website, subtitle: Subtitles.website, cellStyle: .value1, action: { [weak self] context in
                    self?.present(url: Links.website, from: context.viewController)
                }),
                AboutItem(title: Titles.blog, subtitle: Subtitles.blog, cellStyle: .value1, action: { [weak self] context in
                    self?.present(url: Links.blog, from: context.viewController)
                })
            ],
            [
                AboutItem(title: Titles.legalAndMore, accessoryType: .disclosureIndicator, action: { context in
                    context.showSubmenu(title: Titles.legalAndMore, configuration: SimplenoteLegalAndMoreSubmenuConfiguration())
                })
            ],
            [
                AboutItem(title: Titles.automatticFamily, accessoryType: .disclosureIndicator, hidesSeparator: true, action: { [weak self] context in
                    self?.present(url: Links.automatticFamily, from: context.viewController)
                }),
                AboutItem(title: "", cellStyle: .appLogos)
            ],
            [
                AboutItem(title: Titles.workWithUs, subtitle: Subtitles.workWithUs, cellStyle: .subtitle, accessoryType: .disclosureIndicator, action: { [weak self] context in
                    self?.present(url: Links.workWithUs, from: context.viewController)
                })
            ]
        ]
    }

    private func present(url: URL, from viewController: UIViewController) {
        let vc = SFSafariViewController(url: url)
        viewController.present(vc, animated: true, completion: nil)
    }

    func dismissScreen(_ actionContext: AboutItemActionContext) {
        actionContext.viewController.presentingViewController?.dismiss(animated: true)
    }

    func willShow(viewController: UIViewController) {}

    func didHide(viewController: UIViewController) {}

    // Provides app info to display in the header of the about screen.
    //
    static var appInfo: AboutScreenAppInfo {
        let name = "Simplenote"        // (Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String) ?? ""
        let version = "4.47"  //(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? ""
        let versionString = NSLocalizedString("Version %@", comment: "The app's version. %@ will be replaced by the current version number")

        return AboutScreenAppInfo(name: name,
                                  version: String(format: versionString, version),
                                  icon: UIImage(named: "simplenote-logo")!)
    }

    private enum Titles {
        static let rateUs           = NSLocalizedString("Rate us", comment: "Title of button that allows the user to rate the app in the App Store")
        static let twitter          = NSLocalizedString("Twitter", comment: "Title of a button linking to the app's Twitter profile")
        static let website          = NSLocalizedString("Website", comment: "Title of a button linking to the app's website")
        static let blog             = NSLocalizedString("Blog", comment: "Title of a button linking to the app's blog")
        static let legalAndMore     = NSLocalizedString("Legal and more", comment: "Title of a button linking to a list of legal documents like privacy policy, terms of service, etc")
        static let automatticFamily = NSLocalizedString("Automattic family", comment: "Title of a button linking to the Automattic website")
        static let workWithUs       = NSLocalizedString("Work with us", comment: "Title of a button linking to the Automattic Work With Us web page")
    }

    private enum Subtitles {
        static let website          = "simplenote.com"
        static let blog             = "simplenote.com/blog"
        static let twitter          = "@simplenoteapp"
        static let workWithUs       = NSLocalizedString("Join from anywhere", comment: "Subtitle for button displaying the Automattic Work With Us web page, indicating that Automattic employees can work from anywhere in the world")
    }

    private enum Links {
        static let rateUs           = URL(string: "https://itunes.apple.com/app/id289429962?mt=8&action=write-review")!
        static let twitter          = URL(string: "https://twitter.com/simplenoteapp")!
        static let website          = URL(string: "https://simplenote.com")!
        static let blog             = URL(string: "https://simplenote.com/blog/")!
        static let workWithUs       = URL(string: "https://automattic.com/work-with-us")!
        static let automatticFamily = URL(string: "https://automattic.com")!
    }
}


class SimplenoteLegalAndMoreSubmenuConfiguration: AboutScreenConfiguration {
    lazy var sections: [[AboutItem]] = {
        [
            [
                linkItem(title: Titles.termsOfService, url: Links.termsOfService),
                linkItem(title: Titles.privacyPolicy, url: Links.privacyPolicy),
                linkItem(title: Titles.ccpa, url: Links.ccpa),
                linkItem(title: Titles.sourceCode, url: Links.sourceCode)
            ]
        ]
    }()

    private func linkItem(title: String, url: URL) -> AboutItem {
        AboutItem(title: title, action: { [weak self] context in
            self?.present(url: url, from: context.viewController)
        })
    }

    private func present(url: URL, from viewController: UIViewController) {
        let vc = SFSafariViewController(url: url)
        viewController.present(vc, animated: true, completion: nil)
    }

    func dismissScreen(_ actionContext: AboutItemActionContext) {
        actionContext.viewController.presentingViewController?.dismiss(animated: true)
    }

    func willShow(viewController: UIViewController) {}

    func didHide(viewController: UIViewController) {}

    private enum Titles {
        static let termsOfService     = NSLocalizedString("Terms of Service", comment: "Title of button that displays the App's terms of service")
        static let privacyPolicy      = NSLocalizedString("Privacy Policy", comment: "Title of button that displays the App's privacy policy")
        static let ccpa               = NSLocalizedString("Privacy Notice for California Users", comment: "Simplenote terms of service")
        static let sourceCode         = NSLocalizedString("Source Code", comment: "Title of button that displays the App's source code information")
        static let acknowledgements   = NSLocalizedString("Acknowledgements", comment: "Title of button that displays the App's acknoledgements")
    }

    private enum Links {
        static let termsOfService = URL(string: "https://simplenote.com/terms/")!
        static let privacyPolicy = URL(string: "https://automattic.com/privacy/")!
        static let ccpa = URL(string: "https://automattic.com/privacy/#california-consumer-privacy-act-ccpa")!
        static let sourceCode = URL(string: "https://github.com/automattic/simplenote-ios")!
        static let acknowledgements: URL = URL(string: "https://simplenote.com/")! // URL(string: Bundle.main.url(forResource: "acknowledgements", withExtension: "html")?.absoluteString ?? "")!
    }
}
