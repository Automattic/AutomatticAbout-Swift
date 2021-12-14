import UIKit
import AutomatticAbout

class ViewController: UIViewController {

    @IBAction func showTapped() {
        let configuration = AppAboutScreenConfiguration()
        let controller = AutomatticAboutScreen.controller(appInfo: AppAboutScreenConfiguration.appInfo,
                                                          configuration: configuration)
        present(controller, animated: true, completion: nil)
    }

    @IBAction func dayOneTapped() {
        let configuration = DayOneAboutScreenConfiguration()
        let controller = AutomatticAboutScreen.controller(appInfo: DayOneAboutScreenConfiguration.appInfo,
                                                          configuration: configuration)
        present(controller, animated: true, completion: nil)
    }

    @IBAction func pocketCastsTapped() {
        let configuration = PocketCastsAboutScreenConfiguration()
        let controller = AutomatticAboutScreen.controller(appInfo: PocketCastsAboutScreenConfiguration.appInfo,
                                                          configuration: configuration)
        present(controller, animated: true, completion: nil)
    }

    @IBAction func simplenoteTapped() {
        let configuration = SimplenoteAboutScreenConfiguration()
        let controller = AutomatticAboutScreen.controller(appInfo: SimplenoteAboutScreenConfiguration.appInfo,
                                                          configuration: configuration)
        present(controller, animated: true, completion: nil)
    }

    @IBAction func tumblrTapped() {
        let configuration = TumblrAboutScreenConfiguration()
        let controller = AutomatticAboutScreen.controller(appInfo: TumblrAboutScreenConfiguration.appInfo,
                                                          configuration: configuration)
        present(controller, animated: true, completion: nil)
    }

    @IBAction func wooTapped() {
        let configuration = WooAboutScreenConfiguration()
        let controller = AutomatticAboutScreen.controller(appInfo: WooAboutScreenConfiguration.appInfo,
                                                          configuration: configuration)
        present(controller, animated: true, completion: nil)
    }
}
