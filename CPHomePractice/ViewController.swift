//
//  ViewController.swift
//  CPHomePractice
//
//  Created by Wilson on 2022/9/11.
//

import UIKit

class ViewController: UIViewController {

    // TODO: struct test, api test

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func testButtonTapped(_ sender: Any) {

        APIManager.shared.fetch(query: Users()) { response, error, resultDict in
            if let resultDict = resultDict {
                print(resultDict)
            }
        }

        APIManager.shared.fetch(query: User(), parameters: [
            "id": "4dc70521-22bb-4396-b37a-4a927c66d43b"
        ]) { response, error, resultDict in
            if let resultDict = resultDict {
                print(resultDict)
            }
        }

    }

}

