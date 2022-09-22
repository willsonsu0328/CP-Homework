//
//  BaseTableViewCell.swift
//  CPHomePractice
//
//  Created by Wilson on 2022/9/22.
//

import UIKit

struct BaseTableViewItem {

    var title: String?
    var handler: ((_ indexPath: IndexPath) -> Void)?
}

class QueryTableViewCell: UITableViewCell {

    static let reuseIdentifier = "QueryTableViewCell"

    @IBOutlet weak var titleLabel: UILabel!

    var item: BaseTableViewItem? {
        didSet {
            renderView()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        setupView()
    }

    func setupView() {
        titleLabel.text = " "
        titleLabel.font = .systemFont(ofSize: 20.0)
    }

    func renderView() {
        guard let item = item else { return }
        self.titleLabel.text = item.title
    }

}
