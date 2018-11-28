import UIKit

public class HeaderView : UIView {
    
    @IBOutlet weak var label : UILabel!
    
    @IBOutlet weak var heightConstraint : NSLayoutConstraint!
    
    @IBOutlet weak internal var contentView: UIView!


    
    @IBOutlet weak var headerViewBottomEqualInnerHeaderBottom : NSLayoutConstraint!

    lazy var preferredMaximumHeight : CGFloat = {
        return self.bounds.size.height
    }()

    
    lazy var preferredMinimumHeight : CGFloat = {
        let minContentSize = self.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return minContentSize.height
    }()

}
