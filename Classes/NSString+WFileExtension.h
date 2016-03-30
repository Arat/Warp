//
//  WFileExtension.h
//  Warp
//
//  Created by Lukas on 13.7.08.
//  Copyright 2008 TwoManShow. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * TODO: nahradit MobileCoreServices
 */
@interface NSString (WFileExtension)

/*
 * Zjisiti jestli dokazeme otevrit
 */
- (BOOL) canOpen;

/*
 * Seznam kocovek obrazku
 */
- (NSArray *) extImage;

/*
 * Zjisiti jestli je koncovka typu obrazek
 */
- (BOOL) isImage;

/*
 * Seznam kocovek audio
 */
- (NSArray *) extAudio;

/*
 * Zjisiti jestli je koncovka typu audio
 */
- (BOOL) isAudio;

/*
 * Seznam kocovek video souboru
 */
- (NSArray *) extVideo;

/*
 * Zjisiti jestli je koncovka typu video
 */
- (BOOL) isVideo;

- (BOOL) isStreamedVideo;

/*
 * Seznam kocovek textovych souboru
 */
- (NSArray *) extText;

/*
 * Zjisiti jestli je koncovka typu text
 */
- (BOOL) isText;

/*
 * Seznam kocovek dokumentu
 */
- (NSArray *) extDocument;

/*
 * Zjisiti jestli je koncovka typu dokument
 */
- (BOOL) isDocument;

/*
 * Seznam kocovek bundle dokumentu
 */
- (NSArray *) extBundle;

/*
 * Zjisiti jestli je koncovka typu document bundle
 */
- (BOOL) isBundle;

/*
 * Seznam kocovek archivu
 */
- (NSArray *) extArchive;

/*
 * Zjisiti jestli je koncovka typu archiv
 */
- (BOOL) isArchive;

/*
 * Zjisiti jestli umime archiv rozbalit
 */
- (BOOL) canUnarchive;

- (NSString *) stringByStrippingHTML;

@end
