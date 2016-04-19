//
//  WViewDataSectionProtocol.h
//  Warp
//
//  Created by Lukáš Foldýna on 19/04/16.
//  Copyright © 2016 TwoManShow. All rights reserved.
//

@import Foundation;
#import "WViewDataObjectProtocol.h"


@protocol WViewDataSectionProtocol <WViewDataObjectProtocol>

@property (nonatomic, strong) NSString *title;

@end
