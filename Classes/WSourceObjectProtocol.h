//
//  WSourceObjectProtocol.h
//  Ftopia
//
//  Created by Lukáš Foldýna on 12/02/16.
//
//

@import Foundation;


@protocol WSourceObjectProtocol <NSObject>

@property (nonatomic, assign, getter = isInserting) BOOL inserting; // or upload...
@property (nonatomic, assign, getter = isProcessing) BOOL processing; // or download...
@property (nonatomic, assign, getter = isRemoving) BOOL removing;

@end
