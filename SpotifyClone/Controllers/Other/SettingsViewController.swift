//
//  SettingsViewController.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/5/24.
//

import UIKit

class SettingsViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureModels()
        
        title = "Settings"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configureModels() {
        sections.append(Section(title: "Profile", options: [Option(title: "View Your Profile", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.viewProfile()
            }
        })]))
        
        sections.append(Section(title: "Account", options: [Option(title: "Sign Out", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.signOutTapped()
            }
        })]))
    }
    
    private func viewProfile() {
        let vc = ProfileViewController()
        vc.title = "Profile"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func signOutTapped() {
        
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let model = sections[section]
        return model.title
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = model.title
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // call handler to cell
        let model = sections[indexPath.section].options[indexPath.row]
        model.handler()
    }
    
 
}
