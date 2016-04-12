//
//  WViewController.m
//  Warp
//
//  Created by Lukas Foldyna on 03/30/2016.
//  Copyright (c) 2016 Lukas Foldyna. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
	
    __weak WViewController *weakSelf = self;
    
    [self setViewSource:[[WViewDataSource alloc] initWithLabel:@"test"]];
    [self.viewSource setStatusCallback:^(WViewDataSourceState state) {
        switch (state) {
            case WViewDataSourceStateLoading:
                [weakSelf displayLoading];
                break;
            case WViewDataSourceStateLoadingMore:
            case WViewDataSourceStateLoaded:
                [weakSelf hideOverlayer];
                break;
            default:
                [weakSelf displayError];
                break;
        }
    }];
    
    // How to use it manualy
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.viewSource setContent:@[]];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.viewSource setContent:@[@"content"]];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.viewSource setError:[NSError errorWithDomain:@"Test" code:404 userInfo:@{NSLocalizedDescriptionKey: @"Test error description"}]];
            });
        });
    });
    
    // Automatic KVO observing
    // [self.viewSource observerSourceForContentChanges:self.source keyPath:@"items"];
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
