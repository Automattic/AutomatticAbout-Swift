import UIKit
import AutomatticAbout
import SafariServices

class PocketCastsAboutScreenConfiguration: AboutScreenConfiguration {
    var sections: [AboutScreenSection] {
        [
            [
                AboutItem(title: Titles.rateUs, action: { [weak self] context in
                    self?.present(url: Links.rateUs, from: context.viewController)
                }),
                AboutItem(title: Titles.instagram, cellStyle: .value1, action: { [weak self] context in
                    self?.present(url: Links.instagram, from: context.viewController)
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
                    context.showSubmenu(title: Titles.legalAndMore, configuration: PocketCastsLegalAndMoreSubmenuConfiguration())
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
        let name = "Pocket Casts"        // (Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String) ?? ""
        let version = "7.19 (852)"  //(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? ""
        let versionString = NSLocalizedString("Version %@", comment: "The app's version. %@ will be replaced by the current version number")

        return AboutScreenAppInfo(name: name,
                                  version: String(format: versionString, version),
                                  icon: UIImage(named: "pocketcasts-logo")!)
    }

    private enum Titles {
        static let rateUs           = NSLocalizedString("Rate us", comment: "Title of button that allows the user to rate the app in the App Store")
        static let instagram        = NSLocalizedString("Instagram", comment: "Title of a button linking to the app's Instagram profile")
        static let twitter          = NSLocalizedString("Twitter", comment: "Title of a button linking to the app's Twitter profile")
        static let website          = NSLocalizedString("Website", comment: "Title of a button linking to the app's website")
        static let blog             = NSLocalizedString("Blog", comment: "Title of a button linking to the app's blog")
        static let releaseNotes     = NSLocalizedString("Release notes", comment: "Title of a button linking to the app's release notes")
        static let legalAndMore     = NSLocalizedString("Legal and more", comment: "Title of a button linking to a list of legal documents like privacy policy, terms of service, etc")
        static let automatticFamily = NSLocalizedString("Automattic family", comment: "Title of a button linking to the Automattic website")
        static let workWithUs       = NSLocalizedString("Work with us", comment: "Title of a button linking to the Automattic Work With Us web page")
    }

    private enum Subtitles {
        static let website          = "pocketcasts.com"
        static let blog             = "blog.pocketcasts.com"
        static let workWithUs       = NSLocalizedString("Join from anywhere", comment: "Subtitle for button displaying the Automattic Work With Us web page, indicating that Automattic employees can work from anywhere in the world")
    }

    private enum Links {
        static let rateUs           = URL(string: "https://itunes.apple.com/app/id414834813?mt=8&action=write-review")!
        static let instagram        = URL(string: "https://www.instagram.com/pocketcasts")!
        static let twitter          = URL(string: "https://twitter.com/pocketcasts")!
        static let website          = URL(string: "https://pocketcasts.com/")!
        static let blog             = URL(string: "https://blog.pocketcasts.com/")!
        static let releaseNotes     = URL(string: "https://pocketcasts.com/")!  // Link to release notes – I can't tell if this is in the app or available online
        static let automatticFamily = URL(string: "https://automattic.com")!
        static let workWithUs       = URL(string: "https://automattic.com/work-with-us")!
    }
}


class PocketCastsLegalAndMoreSubmenuConfiguration: AboutScreenConfiguration {
    lazy var sections: [[AboutItem]] = {
        [
            [
                linkItem(title: Titles.termsOfUse, url: Links.termsOfUse),
                linkItem(title: Titles.termsOfUseGeneral, url: Links.termsOfUseGeneral),
                linkItem(title: Titles.termsOfUsePaid, url: Links.termsOfUsePaid),
                linkItem(title: Titles.privacyPolicy, url: Links.privacyPolicy),
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
        static let termsOfUse        = NSLocalizedString("Terms of Use", comment: "Title of button that displays the App's terms of use")
        static let termsOfUseGeneral = NSLocalizedString("Terms of Use – General", comment: "Title of button that displays the App's general terms of use")
        static let termsOfUsePaid    = NSLocalizedString("Terms of Use – Paid Services", comment: "Title of button that displays the App's paid services terms of use")
        static let privacyPolicy     = NSLocalizedString("Privacy Policy", comment: "Title of button that displays the App's privacy policy")
    }

    private enum Links {
        static let termsOfUse        = URL(string: "https://support.pocketcasts.com/article/terms-of-use-overview/")!
        static let termsOfUseGeneral = URL(string: "https://support.pocketcasts.com/article/general-terms-of-use/")!
        static let termsOfUsePaid    = URL(string: "https://support.pocketcasts.com/article/terms-of-use/")!
        static let privacyPolicy     = URL(string: "https://support.pocketcasts.com/article/privacy-policy/")!
    }
}
