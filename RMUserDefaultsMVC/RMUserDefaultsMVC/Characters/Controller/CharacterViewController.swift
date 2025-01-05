//
//  CharacterViewController.swift
//  RMUserDefaultsMVC
//
//  Created by Ибрагим Габибли on 28.12.2024.
//

import UIKit
import SnapKit

class CharacterViewController: UIViewController {
    lazy var characterView: CharacterView = {
        let view = CharacterView(frame: .zero)
        view.characterViewController = self
        return view
    }()

    let characterTableViewDataSource = CharacterTableViewDataSource()

    override func loadView() {
        super.loadView()
        view = characterView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        getCharacters()
    }

    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        characterView.configureTableView(dataSource: characterTableViewDataSource)
    }

    private func setupNavigationBar() {
        title = "Characters"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .white
    }

    private func getCharacters() {
        if let savedCharacters = StorageManager.shared.loadCharacters() {
            characterTableViewDataSource.characters = savedCharacters
            characterView.tableView.reloadData()
            return
        }

        NetworkManager.shared.getCharacters { [weak self] result in
            switch result {
            case .success(let character):
                DispatchQueue.main.async {
                    self?.characterTableViewDataSource.characters = character
                    self?.characterView.tableView.reloadData()
                    StorageManager.shared.saveCharacters(character)
                }
            case .failure(let error):
                print("Failed to fetch drinks: \(error.localizedDescription)")
            }
        }
    }
}
