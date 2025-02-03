//
//  SegmentioBuilder.swift
//  Cario
//
//  Created by Sinakhanjani on 7/26/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import Segmentio
import UIKit

struct SegmentioBuilder {
    /*
     static func setupBadgeCountForIndex(_ segmentioView: Segmentio, index: Int) {
     segmentioView.addBadge(
     at: index,
     count: 10,
     color: ColorPalette.coral
     )
     }
     */
    static func buildSegmentioView(segmentioView: Segmentio, segmentioStyle: SegmentioStyle, segmentioPosition: SegmentioPosition = .fixed(maxVisibleItems: 3)) {
        segmentioView.setup(
            content: segmentioContent(),
            style: segmentioStyle,
            options: segmentioOptions(segmentioStyle: segmentioStyle, segmentioPosition: segmentioPosition)
        )
    }
    
    private static func segmentioContent() -> [SegmentioItem] {
        return [
            SegmentioItem(title: "قوانین و محرمانگی", image: nil),
            SegmentioItem(title: "افزایش امتیاز", image: nil),
            SegmentioItem(title: "سوالات رایج", image: nil),
            SegmentioItem(title: "تماس با ما", image: nil),
            SegmentioItem(title: "درباره ما", image: nil),
            SegmentioItem(title: "مرکز پیام", image: nil),
        ]
    }
    
    private static func segmentioOptions(segmentioStyle: SegmentioStyle, segmentioPosition: SegmentioPosition = .fixed(maxVisibleItems: 3)) -> SegmentioOptions {
        var imageContentMode = UIView.UIView.ContentMode.center
        switch segmentioStyle {
        case .imageBeforeLabel, .imageAfterLabel:
            imageContentMode = .scaleAspectFit
        default:
            break
        }
        
        return SegmentioOptions(
            backgroundColor: #colorLiteral(red: 0.9078338742, green: 0.9129192233, blue: 0.9254644513, alpha: 1),
            segmentPosition: segmentioPosition,
            scrollEnabled: true,
            indicatorOptions: segmentioIndicatorOptions(),
            horizontalSeparatorOptions: segmentioHorizontalSeparatorOptions(),
            verticalSeparatorOptions: segmentioVerticalSeparatorOptions(),
            imageContentMode: imageContentMode,
            labelTextAlignment: .center,
            labelTextNumberOfLines: 1,
            segmentStates: segmentioStates(),
            animationDuration: 0.3
        )
    }
    
    private static func segmentioStates() -> SegmentioStates {
        let font = UIFont.iranSansBoldFont(size: 13)
        return SegmentioStates(
            defaultState: segmentioState(
                backgroundColor: .clear,
                titleFont: font,
                titleTextColor: #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            ),
            selectedState: segmentioState(
                backgroundColor: #colorLiteral(red: 0.8589997888, green: 0.8527907729, blue: 0.8637538552, alpha: 1),
                titleFont: font,
                titleTextColor: #colorLiteral(red: 0.1262665689, green: 0.5873628855, blue: 0.9524402022, alpha: 1)
            ),
            highlightedState: segmentioState(
                backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
                titleFont: font,
                titleTextColor: #colorLiteral(red: 0.1344881654, green: 0.1894396544, blue: 0.2187974453, alpha: 1)
            )
        )
    }
    
    private static func segmentioState(backgroundColor: UIColor, titleFont: UIFont, titleTextColor: UIColor) -> SegmentioState {
        return SegmentioState(
            backgroundColor: backgroundColor,
            titleFont: titleFont,
            titleTextColor: titleTextColor
        )
    }
    
    private static func segmentioIndicatorOptions() -> SegmentioIndicatorOptions {
        return SegmentioIndicatorOptions(
            type: .bottom,
            ratio: 1,
            height: 5,
            color: #colorLiteral(red: 0.1262665689, green: 0.5873628855, blue: 0.9524402022, alpha: 1)
        )
    }
    
    private static func segmentioHorizontalSeparatorOptions() -> SegmentioHorizontalSeparatorOptions {
        return SegmentioHorizontalSeparatorOptions(
            type: .topAndBottom,
            height: 0.3,
            color: #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        )
    }
    
    private static func segmentioVerticalSeparatorOptions() -> SegmentioVerticalSeparatorOptions {
        return SegmentioVerticalSeparatorOptions(
            ratio: 1,
            color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        )
    }
    
    
}
