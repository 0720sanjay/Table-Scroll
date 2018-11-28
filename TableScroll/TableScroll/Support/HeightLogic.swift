import UIKit


func finalHeaderHeight(deltaContentOffset: CGPoint, contentInset: UIEdgeInsets, headerHeight : CGFloat, preferredMinimumHeight: CGFloat, preferredMaximumHeight: CGFloat ) -> CGFloat {
    
    let absoluteContentOffset = deltaContentOffset.y + contentInset.top
    let headerHeightDueToScroll = headerHeight - absoluteContentOffset
    let heightNormalisedToMinimumAllowedValue = fmax(preferredMinimumHeight, headerHeightDueToScroll)
    let heightNormalisedToMaximumAllowedValueAlso = fmin(preferredMaximumHeight, heightNormalisedToMinimumAllowedValue)
    
    return heightNormalisedToMaximumAllowedValueAlso
}
