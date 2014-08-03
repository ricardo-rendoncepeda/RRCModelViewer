//
//  RRCiPhoneViewController.m
//  RRCModelViewer
//
//  Created by Ricardo on 1/18/14.
//  Copyright (c) 2014 RendonCepeda. All rights reserved.
//

#import "RRCiPhoneViewController.h"
#import "RRCColladaParser.h"
#import "RRCOpenglesModel.h"

static NSString* const kRRCModelName = @"mushroom";

@interface RRCiPhoneViewController ()

// Model
@property (strong, nonatomic, readwrite) RRCOpenglesModel* openglesModel;

// Effect
@property (strong, nonatomic, readwrite) GLKBaseEffect* effect;

@end

@implementation RRCiPhoneViewController

#pragma mark - View
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%@:- viewDidLoad", [self class]);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"%@:- viewDidAppear", [self class]);
}

#pragma mark - Render
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
}

@end
