
import UIKit

class HeaderViewReduceHeightAtScrollUpDelegate: NSObject {
 
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
            
            //compute offset as vector which indicates the scroll direction
            let offset = newContentOffset.y - oldContentOffset.y

            self.headerView.heightConstraint.constant = reducedHeight(of: self.headerView, by: offset, contentInset: tableView.contentInset, newContentOffset: newContentOffset, oldContentOffset: oldContentOffset)

            self.headerView.headerViewBottomEqualInnerHeaderBottom.constant = reducedOverstretch(of: self.headerView, by: offset, newContentOffset: newContentOffset, oldContentOffset: oldContentOffset)
        }
    }
    
    
    
    func reducedHeight(of headerView: HeaderView, by offset: CGFloat, contentInset: UIEdgeInsets, newContentOffset : CGPoint, oldContentOffset : CGPoint) -> CGFloat {
        
        if shouldReduceRealHeaderHeight(newContentOffset: newContentOffset) {
            if isScrollingUp(newContentOffset: newContentOffset, oldContentOffset: oldContentOffset)
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

    
    func shouldReduceRealHeaderHeight(newContentOffset : CGPoint) -> Bool {
        if newContentOffset.y > 0 { //if scrolling upwards from content offset (0,0)
            return true //then actual height of the header view will decrease
        }else{
            return false
        }
    }
    
   
    func reducedOverstretch(of headerView: HeaderView, by offset: CGFloat, newContentOffset : CGPoint, oldContentOffset : CGPoint) -> CGFloat {
        if isHeaderOverstretched(headerView: headerView) { //if overstretch had occured on scroll down
            if isScrollingUp(newContentOffset: newContentOffset, oldContentOffset: oldContentOffset)
            {
                return reducedConstantForOverstretchInHeaderViewBottomEqualInnerHeaderBottomConstraint(headerView: self.headerView, deltaOffsetOfUpwardScroll: offset)
            }
        }
        return headerView.headerViewBottomEqualInnerHeaderBottom.constant
    }
    
    
    func isScrollingUp(newContentOffset:CGPoint, oldContentOffset:CGPoint) -> Bool {
        let offset = newContentOffset.y - oldContentOffset.y
        if offset > 0 {
            return true
        }else{
            return false
        }
    }
    
   
    func isHeaderOverstretched(headerView: HeaderView) -> Bool {
        if self.headerView.headerViewBottomEqualInnerHeaderBottom.constant < 0  {
            return true
        }else{
            return false
        }
    }
    
    
    func reducedConstantForOverstretchInHeaderViewBottomEqualInnerHeaderBottomConstraint(headerView: HeaderView, deltaOffsetOfUpwardScroll: CGFloat) -> CGFloat  {
        let overstretchVector = headerView.headerViewBottomEqualInnerHeaderBottom.constant
        var newOverstretchVector = overstretchVector + deltaOffsetOfUpwardScroll
        if newOverstretchVector > 0 {
            newOverstretchVector = 0
        }
        return newOverstretchVector
    }
}
