import UIKit

class HeaderViewExpandHeightAtScrollDownDelegate: NSObject {
    
    let kvoKeyPathForContentOffset = "contentOffset"
    let headerView : HeaderView
    unowned let scrollView : UIScrollView
    
    init(headerView: HeaderView, scrollView: UIScrollView) {
        self.headerView = headerView
        self.scrollView = scrollView
        super.init()
        self.scrollView.addObserver(self, forKeyPath: kvoKeyPathForContentOffset, options: [.old, .new], context: nil)
    }
    
    deinit {
        self.scrollView.removeObserver(self, forKeyPath: kvoKeyPathForContentOffset)
    }
    
   
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let tableView = object as? UITableView {
            
            let newContentOffset = change?[.newKey] as! CGPoint
            let oldContentOffset = change?[.oldKey] as! CGPoint
            
            let offset = newContentOffset.y - oldContentOffset.y
            self.headerView.heightConstraint.constant = increasedHeight(of: self.headerView, by: offset, contentInset: tableView.contentInset, newContentOffset: newContentOffset, oldContentOffset: oldContentOffset)
            
            self.headerView.headerViewBottomEqualInnerHeaderBottom.constant = overstretchedValue(of: self.headerView, by: offset, newContentOffset: newContentOffset, oldContentOffset: oldContentOffset)
        }
    }
    
   
    func shouldIncreaseRealHeaderHeight(newContentOffset : CGPoint) -> Bool {
        if newContentOffset.y < 0 { //if scrolling downwards from content offset (0,0)
            return true //then actual height of the header view will increase
        }else{
            return false
        }
    }
    
    
    func isScrollingDown(newContentOffset:CGPoint, oldContentOffset:CGPoint) -> Bool {
        let offset = newContentOffset.y - oldContentOffset.y
        if offset < 0 {
            return true
        }else{
            return false
        }
    }
    
    func increasedHeight(of headerView: HeaderView, by offset: CGFloat, contentInset: UIEdgeInsets, newContentOffset : CGPoint, oldContentOffset : CGPoint) -> CGFloat {
        
        if shouldIncreaseRealHeaderHeight(newContentOffset: newContentOffset) {
            if isScrollingDown(newContentOffset: newContentOffset, oldContentOffset: oldContentOffset)
            {
                let finalHeight = finalHeaderHeight(deltaContentOffset: CGPoint(x: 0.0, y: offset),
                                                    contentInset: contentInset,
                                                    headerHeight: headerView.heightConstraint.constant,
                                                    preferredMinimumHeight: headerView.preferredMinimumHeight,
                                                    preferredMaximumHeight: headerView.preferredMaximumHeight)
                return finalHeight
            }
        }
        return headerView.heightConstraint.constant
    }

    func overstretchedValue(of headerView: HeaderView, by offset: CGFloat, newContentOffset : CGPoint, oldContentOffset : CGPoint) -> CGFloat {
        if needsOverstretching(for: headerView, preferredMaxHeight: headerView.preferredMaximumHeight) {
            if isScrollingDown(newContentOffset: newContentOffset, oldContentOffset: oldContentOffset) {
                return increasedConstantForOverstretchInHeaderViewBottomEqualInnerHeaderBottomConstraint(headerView: headerView, deltaOffsetOfDownwardScroll: offset)
            }
        }
        
        return headerView.headerViewBottomEqualInnerHeaderBottom.constant
    }
    
    func needsOverstretching(for headerView: HeaderView, preferredMaxHeight: CGFloat) -> Bool {
        if headerView.heightConstraint.constant >= preferredMaxHeight {
            return true
        }else{
            return false
        }
    }

    func increasedConstantForOverstretchInHeaderViewBottomEqualInnerHeaderBottomConstraint(headerView: HeaderView, deltaOffsetOfDownwardScroll: CGFloat) -> CGFloat  {
        let overstretchVector = headerView.headerViewBottomEqualInnerHeaderBottom.constant
        let newOverstretchVector = overstretchVector + deltaOffsetOfDownwardScroll
        return newOverstretchVector
    }

}
