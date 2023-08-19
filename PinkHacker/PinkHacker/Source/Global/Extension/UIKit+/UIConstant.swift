//
//  UIConstant.swift
//  PinkHacker
//
//  Created by Woody Lee on 2023/08/19.
//

import UIKit

public var screenWidth: CGFloat {
    UIScreen.main.bounds.width
}

public var screenHeight: CGFloat {
    UIScreen.main.bounds.height
}

public var safeAreaTopPadding: CGFloat {
    UIWindow.current?.safeAreaInsets.top ?? 0
}

public var safeAreaLeftPadding: CGFloat {
    UIWindow.current?.safeAreaInsets.left ?? 0
}

public var safeAreaRightPadding: CGFloat {
    UIWindow.current?.safeAreaInsets.right ?? 0
}

public var safeAreaBottomPadding: CGFloat {
    UIWindow.current?.safeAreaInsets.bottom ?? 0
}

public var safeAreaWidth: CGFloat? {
    let safeAreaFrame = UIWindow.current?.safeAreaLayoutGuide.layoutFrame
    return safeAreaFrame?.width
}

public var safeAreaHeight: CGFloat? {
    let safeAreaFrame = UIWindow.current?.safeAreaLayoutGuide.layoutFrame
    return safeAreaFrame?.height
}
