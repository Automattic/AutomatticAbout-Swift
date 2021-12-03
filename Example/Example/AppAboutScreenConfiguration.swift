import UIKit
import AutomatticAbout
import SafariServices

class AppAboutScreenConfiguration: AboutScreenConfiguration {
    var sections: [AboutScreenSection] {
        [
            [
                AboutItem(title: "Rate Us"),
                AboutItem(title: "Blog", subtitle: "blog.wordpress.com", cellStyle: .value1, action: { [weak self] context in
                    self?.present(url: URL(string: "https://blog.wordpress.com")!, from: context.viewController)
                }),
                AboutItem(title: "Twitter", subtitle: "@WordPressiOS", cellStyle: .value1, action: { [weak self] context in
                    self?.present(url: URL(string: "https://blog.wordpress.com")!, from: context.viewController)
                })
            ],
            [
                AboutItem(title: "Legal and More", accessoryType: .disclosureIndicator, action: { context in
                    context.showSubmenu(title: "Legal and More", configuration: LegalAndMoreSubmenuConfiguration())
                })
            ],
            [
                AboutItem(title: "Our Apps", accessoryType: .disclosureIndicator, hidesSeparator: true, action: { [weak self] context in
                    self?.present(url: URL(string: "https://automattic.com")!, from: context.viewController)
                }),
                AboutItem(title: "", cellStyle: .appLogos)
            ],
            [
                AboutItem(title: "Work With Us", subtitle: "Join From Anywhere", cellStyle: .subtitle, accessoryType: .disclosureIndicator, action: { [weak self] context in
                    self?.present(url: URL(string: "https://automattic.com/work-with-us")!, from: context.viewController)
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
        let name = (Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String) ?? ""
        let version = (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? ""

        return AboutScreenAppInfo(name: name,
                                  version: "Version \(version)",
                                  icon: UIImage(named: "AppIcon")!)
    }
}


class LegalAndMoreSubmenuConfiguration: AboutScreenConfiguration {
    lazy var sections: [[AboutItem]] = {
        [
            [
                linkItem(title: Titles.termsOfService, url: Links.termsOfService),
                linkItem(title: Titles.privacyPolicy, url: Links.privacyPolicy),
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

    func willShow(viewController: UIViewController) {
    }

    func didHide(viewController: UIViewController) {
    }

    private enum Titles {
        static let termsOfService     = NSLocalizedString("Terms of Service", comment: "Title of button that displays the App's terms of service")
        static let privacyPolicy      = NSLocalizedString("Privacy Policy", comment: "Title of button that displays the App's privacy policy")
        static let sourceCode         = NSLocalizedString("Source Code", comment: "Title of button that displays the App's source code information")
    }

    private enum Links {
        static let termsOfService = URL(string: "https://wordpress.com/tos/")!
        static let privacyPolicy = URL(string: "https://wordpress.com/privacy/")!
        static let sourceCode = URL(string: "https://github.com/automattic/AutomatticAbout-Swift")!
    }
}
