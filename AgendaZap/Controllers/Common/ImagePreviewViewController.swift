//
//  ImagePreviewViewController.swift
//  AgendaZap
//
//  Created by Aditya Patel on 5/26/20.
//  Copyright © 2020 AgendaZap. All rights reserved.
//

import UIKit

class ImagePreviewViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {

    @IBOutlet var myCollectionView: UICollectionView!
    @IBOutlet var navigationBarview: UIView!
    @IBOutlet var btnRotate: UIButton!
    @IBOutlet var imgBack: UIImageView!
      @IBOutlet var btnBack: UIButton!
    @IBOutlet var imgRotate: UIImageView!
    @IBOutlet var lblNavigationTitle: UILabel!
    
    @IBOutlet var mainContainerView: UIView!
    @IBOutlet var viewButtonPrevious: UIView!
    @IBOutlet var imgPrevious: UIImageView!
    @IBOutlet var btnPrevious: UIButton!
    
    @IBOutlet var viewButtonNext: UIView!
    @IBOutlet var imgNext: UIImageView!
    @IBOutlet var btnNext : UIButton!
    
    var imgArray = [UIImage]()
    var passedContentOffset = IndexPath()
    var currentIndex = IndexPath()
    var boolIsRotateOn:Bool = false
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
     lblNavigationTitle?.font = MySingleton.sharedManager().navigationBarTitleFont
     lblNavigationTitle?.textColor = MySingleton.sharedManager().themeGlobalWhiteColor
     lblNavigationTitle?.text = NSLocalizedString("photos", value:"Photos", comment: "")
        
//     let appDelegate = UIApplication.shared.delegate as! AppDelegate
//     appDelegate.myOrientation = .landscape
        
        self.view.backgroundColor=UIColor.black
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing=0
        layout.minimumLineSpacing=0
        layout.scrollDirection = .horizontal
        
        myCollectionView!.collectionViewLayout = layout
       // myCollectionView = UICollectionView(frame: CGRect, collectionViewLayout: layout)
        myCollectionView.delegate=self
        myCollectionView.dataSource=self
        myCollectionView.register(ImagePreviewFullViewCell.self, forCellWithReuseIdentifier: "Cell")
      
        myCollectionView.isPagingEnabled = true
        myCollectionView.scrollToItem(at: passedContentOffset, at: .left, animated: true)
        btnRotate.addTarget(self, action: #selector(btnRotateClicked), for: .touchUpInside)
        
        btnNext.addTarget(self, action: #selector(btnNextClicked), for: .touchUpInside)
        btnPrevious.addTarget(self, action: #selector(btnPrevioudClicked), for: .touchUpInside)
        btnBack.addTarget(self, action: #selector(btnBackClicked), for: .touchUpInside)
        
    }
    @objc func btnBackClicked(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
      }
     @objc func btnNextClicked(sender: UIButton!) {
        let indexPath = IndexPath(item: passedContentOffset.row + 1, section: 0)
        if(indexPath.row < imgArray.count){
        passedContentOffset = indexPath
        myCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        }
     }
    @objc func btnPrevioudClicked(sender: UIButton!) {
       
         let indexPath = IndexPath(item: passedContentOffset.row - 1, section: 0)
        if(indexPath.row >= 0){
            myCollectionView.scrollToItem(at: indexPath,  at: .right, animated: true)
            passedContentOffset = indexPath
        }
       
    }
    
    @objc func btnRotateClicked(sender: UIButton!) {
        
        sender.isSelected = !sender.isSelected
        
        if(boolIsRotateOn == false)
        {
          boolIsRotateOn = true
        }
        else
        {
          boolIsRotateOn = false
        }
        self.myCollectionView.reloadData()
      
//        if(sender.isSelected == true)
//        {
//            isbtnLandscapeMode = true
//////            var index: Int = 0
//////
//////            for imageInArray in self.imgArray
//////            {
//////               // cell?.imgView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
//////                 // cell?.imgView.image =  imageInArray.rotate(radians: -(.pi / 2)
//////                //let image: UIImage = imageInArray.image
////////                self.imgArray[index] = myCollectionView(image: imageInArray.rotate(radians: -(.pi / 2)))
////////                self.photosData[index] = imageInArray.rotate(radians: -(.pi / 2))
//////               // index = index + 1
//////            }
//
////            let value =  UIInterfaceOrientation.landscapeRight.rawValue
////            UIDevice.current.setValue(value, forKey: "orientation")
////            UIViewController.attemptRotationToDeviceOrientation()
//
//        }
//        else
//        {
//            isbtnLandscapeMode = false
////           let value =  UIInterfaceOrientation.portrait.rawValue
////          UIDevice.current.setValue(value, forKey: "orientation")
////          UIViewController.attemptRotationToDeviceOrientation()
//        }
//        myCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImagePreviewFullViewCell
    //    cell.imgView.image=imgArray[indexPath.row]
    //    if(boolIsRotateOn)
    //    {
    //      cell.imgView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
    //    }
        var storeImage = imgArray[indexPath.row]
        if(boolIsRotateOn)
        {
          storeImage = storeImage.rotate(radians: CGFloat(Double.pi/2))
        }
        cell.imgView.image = storeImage
        return cell
      }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in myCollectionView.visibleCells {
            let indexPath = myCollectionView.indexPath(for: cell)
            
            passedContentOffset = indexPath!
        }
    }

    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard let flowLayout = myCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        flowLayout.itemSize = self.view.frame.size
        
        flowLayout.invalidateLayout()
        
        myCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        var width = self.view.bounds.size.width
//        if UIDevice.current.orientation.isLandscape {
//            print("Landscape")
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                  appDelegate.myOrientation = .portrait
//                width  = self.view.bounds.size.height
//        } else {
//            print("Portrait")
//             let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                  appDelegate.myOrientation = .landscape
//                width  = self.view.bounds.size.width
//        }
        
        super.viewWillTransition(to: size, with: coordinator)
        let offset = myCollectionView.contentOffset
        let index = round(offset.x / width)
        let newOffset = CGPoint(x: index * size.width, y: offset.y)
        
        myCollectionView.setContentOffset(newOffset, animated: false)
        
        coordinator.animate(alongsideTransition: { (context) in
            self.myCollectionView.reloadData()
            
            self.myCollectionView.setContentOffset(newOffset, animated: false)
        }, completion: nil)
    }

}


class ImagePreviewFullViewCell: UICollectionViewCell, UIScrollViewDelegate {

    var scrollImg: UIScrollView!
    var imgView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        scrollImg = UIScrollView()
        scrollImg.delegate = self
        scrollImg.alwaysBounceVertical = false
        scrollImg.alwaysBounceHorizontal = false
        scrollImg.showsVerticalScrollIndicator = true
        scrollImg.flashScrollIndicators()

        scrollImg.minimumZoomScale = 1.0
        scrollImg.maximumZoomScale = 4.0

        let doubleTapGest = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapScrollView(recognizer:)))
        doubleTapGest.numberOfTapsRequired = 2
        scrollImg.addGestureRecognizer(doubleTapGest)

        self.addSubview(scrollImg)

        imgView = UIImageView()
        imgView.image = UIImage(named: "user3")
        scrollImg.addSubview(imgView!)
        imgView.contentMode = .scaleAspectFit
    }

    @objc func handleDoubleTapScrollView(recognizer: UITapGestureRecognizer) {
        if scrollImg.zoomScale == 1 {
            scrollImg.zoom(to: zoomRectForScale(scale: scrollImg.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
        } else {
            scrollImg.setZoomScale(1, animated: true)
        }
    }

    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imgView.frame.size.height / scale
        zoomRect.size.width  = imgView.frame.size.width  / scale
        let newCenter = imgView.convert(center, from: scrollImg)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imgView
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        scrollImg.frame = self.bounds
        imgView.frame = self.bounds
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        scrollImg.setZoomScale(1, animated: true)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
