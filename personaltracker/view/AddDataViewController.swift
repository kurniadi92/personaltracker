//
//  AddDataViewController.swift
//  personaltracker
//
//  Created by kur niadi  on 11/07/22.
//

import UIKit

class AddDataViewController: UIViewController {

    @IBOutlet var categoryCollectionView: UICollectionView!
    private let imagePickerHelper = ImagePickerHelper()
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func imageTap(_ sender: Any) {
        imagePickerHelper.getImage(root: self) { [weak self] validImage in
            self?.imageView.image = validImage
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
