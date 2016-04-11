//
//  WTableView.h
//  Warp
//
//  Created by Lukáš Foldýna on 30.9.09.
//  Copyright 2009 TwoManShow. All rights reserved.
//

@import Foundation;
@import UIKit;


/*
 * Pridava moznost zobrazeni stinu kolem obsahu tabulky
 */
@interface WTableView : UITableView

@property (nonatomic, assign) BOOL displayShadow;

@end
