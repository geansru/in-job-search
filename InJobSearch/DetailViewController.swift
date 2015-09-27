//
//  DetailViewController.swift
//  InJobSearch
//
//  Created by Dmitriy Roytman on 26.09.15.
//  Copyright (c) 2015 Dmitriy Roytman. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var webView: UIWebView!

    @IBAction func goToSafari(sender: UIBarButtonItem) {
        
    }

    var detailItem: Job? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail: Job = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.title
            }
            
            if let web = webView {
                webView.loadHTMLString(detail.content, baseURL: nil)
            }
            
            if isViewLoaded() {
                title = detail.pubDate
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

