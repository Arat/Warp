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
@property (nonatomic, readonly) BOOL canOpen;

/*
 * Seznam kocovek obrazku
 */
@property (nonatomic, readonly, copy) NSArray *extImage;

/*
 * Zjisiti jestli je koncovka typu obrazek
 */
@property (nonatomic, getter=isImage, readonly) BOOL image;

/*
 * Seznam kocovek audio
 */
@property (nonatomic, readonly, copy) NSArray *extAudio;

/*
 * Zjisiti jestli je koncovka typu audio
 */
@property (nonatomic, getter=isAudio, readonly) BOOL audio;

/*
 * Seznam kocovek video souboru
 */
@property (nonatomic, readonly, copy) NSArray *extVideo;

/*
 * Zjisiti jestli je koncovka typu video
 */
@property (nonatomic, getter=isVideo, readonly) BOOL video;

@property (nonatomic, getter=isStreamedVideo, readonly) BOOL streamedVideo;

/*
 * Seznam kocovek textovych souboru
 */
@property (nonatomic, readonly, copy) NSArray *extText;

/*
 * Zjisiti jestli je koncovka typu text
 */
@property (nonatomic, getter=isText, readonly) BOOL text;

/*
 * Seznam kocovek dokumentu
 */
@property (nonatomic, readonly, copy) NSArray *extDocument;

/*
 * Zjisiti jestli je koncovka typu dokument
 */
@property (nonatomic, getter=isDocument, readonly) BOOL document;

/*
 * Seznam kocovek bundle dokumentu
 */
@property (nonatomic, readonly, copy) NSArray *extBundle;

/*
 * Zjisiti jestli je koncovka typu document bundle
 */
@property (nonatomic, getter=isBundle, readonly) BOOL bundle;

/*
 * Seznam kocovek archivu
 */
@property (nonatomic, readonly, copy) NSArray *extArchive;

/*
 * Zjisiti jestli je koncovka typu archiv
 */
@property (nonatomic, getter=isArchive, readonly) BOOL archive;

/*
 * Zjisiti jestli umime archiv rozbalit
 */
@property (nonatomic, readonly) BOOL canUnarchive;

@property (nonatomic, readonly, copy) NSString *stringByStrippingHTML;

@end
