//
//  CycleView.swift
//  Swift无限轮播
//
//  Created by 运满满 on 2020/4/2.
//  Copyright © 2020 jimwan. All rights reserved.
//

import UIKit

let cycleViewCellID = "cycleCell"
let kScreenWidth = UIScreen.main.bounds.size.width

class CycleView: UIView {
    
    var timer:Timer?
    var interval:Double = 2
    var imageNames:[String] = [] // 用来循环展示的图片
    lazy var collectionView:UICollectionView = { [unowned self] in
        var collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.minimumLineSpacing = 0
        collectionLayout.minimumInteritemSpacing = 0
        collectionLayout.scrollDirection = .horizontal
        collectionLayout.itemSize = self.bounds.size
        
        let collectionV = UICollectionView(frame: self.bounds, collectionViewLayout: collectionLayout)
        collectionV.isPagingEnabled = true
        collectionV.dataSource = self
        collectionV.delegate = self
        collectionV.showsHorizontalScrollIndicator = false
        collectionV.showsVerticalScrollIndicator = false
        collectionV.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cycleViewCellID)
        collectionV.backgroundColor = UIColor.white
        collectionV.frame = self.bounds
        return collectionV
    }()

    lazy var pageControl:UIPageControl = {[unowned self] in
        var pageControl = UIPageControl()
        pageControl.numberOfPages = self.imageNames.count
        pageControl.currentPageIndicatorTintColor = UIColor.red
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()
    
    init(frame: CGRect,images:[String]) {
        super.init(frame: frame)
        self.imageNames = images
        setupViews()
        startTimer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        addSubview(collectionView)
        collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .right, animated: false)
        addSubview(pageControl)
        pageControl.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { [weak self] t in
           
            if let currentIndexPath = self?.collectionView.indexPathsForVisibleItems.last {
                if currentIndexPath.row + 1 >= (self?.imageNames.count)! + 1 {
                    // 滚动到最后一个了,下一个是走到索引1(即第1个图片,前面还有第0个图片)
                    self?.collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .right, animated: false)
                    self?.pageControl.currentPage = 0
                }else{
                    self?.collectionView.scrollToItem(at: IndexPath(item: currentIndexPath.row+1, section: 0), at: .right, animated: true)
                    self?.pageControl.currentPage = currentIndexPath.row
                }
            }
        })
    }
    
    func stopTimer(){
        timer?.invalidate()
        timer = nil
    }
}

extension CycleView:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNames.count + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cycleViewCellID, for: indexPath)
        var imageView:UIImageView!
        if indexPath.row == 0 {
            // 第一个放最后一张图片
            imageView = UIImageView(image: UIImage(named: imageNames[imageNames.count - 1]))
        }else if indexPath.row == imageNames.count + 1 {
            // 最后一个放第一张图片
            imageView = UIImageView(image: UIImage(named: imageNames[0]))
        }else{
            imageView = UIImageView(image: UIImage(named: imageNames[indexPath.row - 1]))
        }
        imageView.frame = self.bounds
        imageView.frame = cell.contentView.bounds
        cell.contentView.addSubview(imageView)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = Int ((scrollView.contentOffset.x + kScreenWidth * 0.5)/kScreenWidth)
        pageControl.currentPage = index - 1
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startTimer()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int ((scrollView.contentOffset.x + kScreenWidth * 0.5)/kScreenWidth)
        if index == imageNames.count + 1 {
            //已经滑倒最后一个了
            collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .right, animated: false)
        }else if index == 0 {
            // 滑到了第一个了
            collectionView.scrollToItem(at: IndexPath(item: imageNames.count, section: 0), at: .left, animated: false)
        }
    }
}
