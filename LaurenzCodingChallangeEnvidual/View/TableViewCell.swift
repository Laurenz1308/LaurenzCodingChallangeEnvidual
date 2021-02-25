//
//  TableViewCell.swift
//  LaurenzCodingChallangeEnvidual
//
//  Created by Laurenz Hill on 24.02.21.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var updatedLabel: UILabel!
    @IBOutlet weak var stargazersLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    var repository: Repository?
    var saveActionBlock: ((_ repo: Repository) -> Void)? = nil
    
    func configure(with repo: Repository, saved: Bool) {
        self.titleLable.text = repo.name
        self.descriptionLabel.text = repo.description ?? ""
        self.stargazersLabel.text = "⭐️ \(repo.stargazers_count)"
        self.updatedLabel.text = repo.updated_at
        self.button.backgroundColor = saved ? .red : .green
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func buttonTapped(_ sender: Any) {
        if self.saveActionBlock != nil && self.repository != nil {
            saveActionBlock!(self.repository!)
        }
    }
    
}
