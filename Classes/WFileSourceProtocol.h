//
//  WFileSourceProtocol.h
//  Warp
//
//  Created by Lukas on 6.7.08.
//  Copyright 2008 TwoManShow. All rights reserved.
//

@import Foundation;


typedef NS_ENUM(NSInteger, WFileSourceType) {
    WFileSourceTypeSystem = 0, // localni system
    WFileSourceTypeNetwork, // sitovy system
    WFileSourceTypeJolicloud, // jolicloud system
	WFileSourceTypeHttp, // url/http system
	WFileSourceTypeAssetsLibrary, // iOS photo library system
}; // Typy file systemu


typedef NS_ENUM(NSInteger, WFileSourceThumbnailsSize) {
    WFileSourceThumbnailsSizeSmall = 0,
    WFileSourceThumbnailsSizeNormal,
    WFileSourceThumbnailsSizeLarge
};


// notifikace, ktera se posila pri chybe
extern NSString *const WFileSourceErrorNotification;


// block for file system attributes
typedef void (^WFileAttriburesBlock)(NSDictionary *attributtes);

// block for file thumbnail
typedef void (^WFileThumbnailBlock)(NSString *thumbnailPath);

// block for public link
typedef void (^WFilePublicLinkBlock)(NSURL *publicURL);


@class WConnection;
@protocol WFileSourceDelegate;


/*
 * Queue based source and with responses through delegates
 */
@protocol WFileSourceProtocol <NSObject>

@required

- (instancetype) initWithConnection:(WConnection *)connection;// NS_DESIGNATED_INITIALIZER;

/*
 * Sources podporuji vice delegatu najednou
 */
@property (nonatomic, strong, readonly) NSArray *delegates;

/*
 * Pridat delegate
 */
- (void) addDelegate:(id<WFileSourceDelegate>)delegate;

/*
 * Odebrat delegate
 */
- (void) removeDelegate:(id<WFileSourceDelegate>)delegate;

@property (nonatomic, assign, readonly) WFileSourceType type; // Vrati typ zdroje
@property (nonatomic, assign, readonly) BOOL networkBased;
@property (nonatomic, assign, readonly) NSUInteger state; // Vrati stav zdroje
@property (nonatomic, strong) NSString *identifier; // may be used to custom source identification. Defautl value is nil
@property (nonatomic, strong) WConnection *connection; // Odkaz na connection

/*
 * Pripojit se ke zdroji
 */
- (void) connect;

/*
 * Je zdroj pripojen
 */
@property (nonatomic, getter=isConnected, readonly) BOOL connected;

/*
 * Je zdroj zaneprazdnen
 */
@property (nonatomic, getter=isBusy, readonly) BOOL busy;

/*
 * Odpojit zdroj
 */
- (void) disconnect;

@property (nonatomic, strong, readonly) NSString *homePath; // Vrati home path, prvni slozku kam nas zdroj hodil
@property (nonatomic, strong, readonly) NSString *currentPath; // Aktualni cesta

/*
 * Zmeni pozici
 */
- (void) changePath:(NSString *)newPath;

/*
 * Zkontrolovat jestli path existuje
 */
- (void) checkExistenceOfPath:(NSString *)path;

/*
 * Nahrat aktualni adresar, cache se bere v uvahu...
 */
- (void) loadAtPath:(NSString *)path;
- (void) loadAtPath:(NSString *)path info:(id)info;

/*
 * Obnovit aktualni adresar, vymaze se s cache a prepise
 */
- (void) reload;

/*
 * Vytvori novy adresar v adresari
 */
- (void) makeDir:(NSString *)newDir atDirectory:(NSString *)directory;

/*
 * Vymaze adresar
 */
- (void) deleteDirectory:(NSString *)directory;

/*
 * Vytvori novy soubor v adresari
 */
- (void) makeFile:(NSString *)newFile atDirectory:(NSString *)directory;

/*
 * Zkopiruje soubor
 */
- (void) copyFile:(NSString *)file toFile:(NSString *)copyFile;

/*
 * Prejmenuje adresar
 */
- (void) renameFile:(NSString *)file toName:(NSString *)name;

/*
 * Presune soubor do adresare
 */
- (void) moveFile:(NSString *)file toDirectory:(NSString *)directory;

/*
 * Smaze soubor
 */
- (void) deleteFile:(NSString *)file;

/*
 * Zmeni vlastnika souboru
 */
- (void) setOwner:(NSString *)owner forFile:(NSString *)file;

/*
 * Zmeni skupinu souboru
 */
- (void) setGroup:(NSString *)group forFile:(NSString *)file;

/*
 * Zmeni opraveneni souboru
 */
- (void) setPermissions:(NSNumber *)permissions forFile:(NSString *)file;

/*
 * Zmeni opravneni, vlastnika a skupinu souboru
 */
- (void) setPermissions:(NSNumber *)permissions owner:(NSString *)owner group:(NSString *)group forFile:(NSString *)file;

/*
 * Jestli protokol podporuje vyhledavani
 */
@property (nonatomic, readonly) BOOL supportsSearch;

/*
 * Vyhledavani od zadane cesty, podle slova...
 */
- (void) searchPath:(NSString *)path forKeyword:(NSString *)keyword;

/*
 * Vrati informace o file systemu
 */
@property (nonatomic, readonly, copy) NSDictionary *systemAtrributes;
- (void) systemAtrributesWithBlock:(WFileAttriburesBlock)block;

/*
 * Vrati nahled souboru
 */
@property (nonatomic, readonly) BOOL supportsThumbnails;
- (BOOL) supportsThumbnailsWithSize:(WFileSourceThumbnailsSize)thumbnailSize;
- (void) loadThumbnailForFile:(NSString *)file toPath:(NSString *)toPath completion:(WFileThumbnailBlock)completion;
- (void) loadThumbnailForFile:(NSString *)file toPath:(NSString *)toPath completion:(WFileThumbnailBlock)completion size:(WFileSourceThumbnailsSize)size;

/*
 * Vytvori sharable link souboru
 */
@property (nonatomic, readonly) BOOL supportsPublicLinks;
- (void) publicLinkForFile:(NSString *)file completion:(WFilePublicLinkBlock)completion;

@end


/*
 * Po kazde akci se zavola prislusna odpoved, pri chybe dostane NSError,
 * pokud nastane naka jina chyba zavola se source:didReceiveError:
 */
@protocol WFileSourceDelegate <NSObject>

@optional
- (void) source:(id<WFileSourceProtocol>)source didConnectToHost:(NSString *)host error:(NSError *)error;
- (void) source:(id<WFileSourceProtocol>)source didDisconnectFromHost:(NSString *)host;

- (void) source:(id<WFileSourceProtocol>)source didReceiveAuthenticationChallengeToHost:(NSString *)host;
- (void) source:(id<WFileSourceProtocol>)source didCancelAuthenticationChallengeFromHost:(NSString *)host;

- (void) source:(id<WFileSourceProtocol>)source didReceiveError:(NSError *)error;

- (void) source:(id<WFileSourceProtocol>)source didCreateDirectory:(NSString *)dirPath error:(NSError *)error;
- (void) source:(id<WFileSourceProtocol>)source didDeleteDirectory:(NSString *)dirPath error:(NSError *)error;

- (void) source:(id<WFileSourceProtocol>)source didCreateFile:(NSString *)path error:(NSError *)error;
- (void) source:(id<WFileSourceProtocol>)source didDeleteFile:(NSString *)path error:(NSError *)error;

- (void) source:(id<WFileSourceProtocol>)source didDiscoverFilesToDelete:(NSArray *)contents inAncestorDirectory:(NSString *)ancestorDirPath;
- (void) source:(id<WFileSourceProtocol>)source didDiscoverFilesToDelete:(NSArray *)contents inDirectory:(NSString *)dirPath;
- (void) source:(id<WFileSourceProtocol>)source didDeleteDirectory:(NSString *)dirPath inAncestorDirectory:(NSString *)ancestorDirPath error:(NSError *)error;
- (void) source:(id<WFileSourceProtocol>)source didDeleteFile:(NSString *)path inAncestorDirectory:(NSString *)ancestorDirPath error:(NSError *)error;

- (void) source:(id<WFileSourceProtocol>)source didChangeToDirectory:(NSString *)dirPath error:(NSError *)error;
- (void) source:(id<WFileSourceProtocol>)source didReceiveContents:(NSArray *)contents ofDirectory:(NSString *)dirPath error:(NSError *)error;
- (void) source:(id<WFileSourceProtocol>)source didReceiveSearchResults:(NSArray *)results keyword:(NSString *)keyword error:(NSError *)error;

- (void) source:(id<WFileSourceProtocol>)source didRename:(NSString *)fromPath to:(NSString *)toPath error:(NSError *)error;
- (void) source:(id<WFileSourceProtocol>)source didSetPermissionsForFile:(NSString *)path error:(NSError *)error;
- (void) source:(id<WFileSourceProtocol>)source checkedExistenceOfPath:(NSString *)path pathExists:(NSNumber *)exists error:(NSError *)error;

// Transfers
- (void) source:(id<WFileSourceProtocol>)source didCancelTransfer:(NSString *)remotePath;

// Download
- (void) source:(id<WFileSourceProtocol>)source download:(NSString *)path progressedTo:(NSNumber *)percent;
- (void) source:(id<WFileSourceProtocol>)source download:(NSString *)path receivedDataOfLength:(unsigned long long)length;
- (void) source:(id<WFileSourceProtocol>)source downloadDidBegin:(NSString *)remotePath;
- (void) source:(id<WFileSourceProtocol>)source downloadDidFinish:(NSString *)remotePath error:(NSError *)error;

// Upload
- (void) source:(id<WFileSourceProtocol>)source upload:(NSString *)remotePath progressedTo:(NSNumber *)percent;
- (void) source:(id<WFileSourceProtocol>)source upload:(NSString *)remotePath sentDataOfLength:(unsigned long long)length;
- (void) source:(id<WFileSourceProtocol>)source uploadDidBegin:(NSString *)remotePath;
- (void) source:(id<WFileSourceProtocol>)source uploadDidFinish:(NSString *)remotePath error:(NSError *)error;

@end
