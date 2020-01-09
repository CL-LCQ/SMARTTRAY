//
//  RBLViewController.m
//  SimpleChat
//
//  Created by redbear on 14-4-8.
//  Copyright (c) 2014年 redbear. All rights reserved.
//

#import "RBLViewController.h"

#define TEXT_STR @"TEXT_STR"
#define FORM @"FORM"

@interface RBLViewController ()
{
    NSMutableArray *tableData;
}

@end

@implementation RBLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

        //[self ShowWarning];
    
   // tableData = [NSMutableArray array];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.showsVerticalScrollIndicator = NO;
    
   // self.valueLabel.text = @"5";
    
    bleShield = [[BLE alloc] init];
    [bleShield controlSetup];
    bleShield.delegate = self;
    
    self.navigationItem.hidesBackButton = NO;

    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    [self navigationItem].rightBarButtonItem = barButton;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)viewWillAppear:(BOOL)animated{

    self.width = self.view.frame.size.width;
    self.height = self.view.frame.size.height;
   
    self.orderButton.frame = CGRectMake(self.width/2 - 80, self.height, 160, 60);
    self.center = self.orderButton.center ;
    [self.orderButton setTitle:@"ORDER" forState:UIControlStateNormal];
    self.orderButton.hidden= YES;
    // self.orderButton.alpha = 0.1f;
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];

    [super viewWillAppear:animated];
}
-(void) connectionTimer:(NSTimer *)timer
{
    if(bleShield.peripherals.count > 0)
    {
        [bleShield connectPeripheral:[bleShield.peripherals objectAtIndex:0]];
    }
    else
    {
        [activityIndicator stopAnimating];
        self.navigationItem.leftBarButtonItem.enabled = YES;
    }
}

- (IBAction)BLEShieldScan:(id)sender
{
    if (bleShield.activePeripheral)
        if(bleShield.activePeripheral.state == CBPeripheralStateConnected)
        {
            [[bleShield CM] cancelPeripheralConnection:[bleShield activePeripheral]];
            return;
        }
    
    if (bleShield.peripherals)
        bleShield.peripherals = nil;
    
    [bleShield findBLEPeripherals:3];
    
    [NSTimer scheduledTimerWithTimeInterval:(float)3.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
    
    [activityIndicator startAnimating];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    
    
    
}

-(void) bleDidReceiveData:(unsigned char *)data length:(int)length
{
    NSData *d = [NSData dataWithBytes:data length:length];
    //int value = data;
    NSString *string = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
    NSLog(@"content is %@", string);
    //NSLog(@"content is %d", value);
    //NSNumber *form = [NSNumber numberWithBool:YES];
    
   // self.valueLabel.text =  @(value).stringValue;
    self.valueLabel.text = string;
    int valueInt = [string intValue];
//    int valueInt = value;
    //NSLog(@"Data in %d", value);

    if (valueInt<3) {
        NSLog(@"trigger");
        [self ShowWarning];
    }
    else if (valueInt>3){
    
        [self hideWarning];
    }

    
}
-(void)hideWarning{
       //animate button and opa
    //CGRect frame = CGRectMake(self.width/2 - 80, self.height - 200, 160, 60);
    CGPoint newPoint = CGPointMake(self.center.x, self.center.y +100);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0f];
    self.orderButton.center = newPoint;
    //[self.orderButton setAlpha:1.0f];
    [UIView commitAnimations];
    self.orderButton.hidden= YES;

    
    
    
    
}
-(void)ShowWarning{
    self.orderButton.hidden= NO;
    //animate button and opa
    //CGRect frame = CGRectMake(self.width/2 - 80, self.height - 200, 160, 60);
    CGPoint newPoint = CGPointMake(self.center.x, self.center.y -100);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0f];
    self.orderButton.center = newPoint;
    //[self.orderButton setAlpha:1.0f];
    [UIView commitAnimations];
    
    

    
}
-(void)showURL{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.amazon.com/GoodSense-Coated-Aspirin-Reliever-Tablets/dp/B0091RRORA/ref=sr_1_2?s=hpc&ie=UTF8&qid=1454069386&sr=1-2&keywords=aspirin"]];

}

NSTimer *rssiTimer;

-(void) readRSSITimer:(NSTimer *)timer
{
    [bleShield readRSSI];
}

- (void) bleDidDisconnect
{
    NSLog(@"bleDidDisconnect");
    
    [self.navigationItem.leftBarButtonItem setTitle:@"Connect"];
    [activityIndicator stopAnimating];
    self.navigationItem.leftBarButtonItem.enabled = YES;
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

-(void) bleDidConnect
{
    [activityIndicator stopAnimating];
    self.navigationItem.leftBarButtonItem.enabled = YES;
    [self.navigationItem.leftBarButtonItem setTitle:@"Disconnect"];
    
    NSLog(@"bleDidConnect");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)orderButtonPressed:(id)sender {
    [self showURL];
}

- (BOOL)prefersStatusBarHidden { return YES; }
@end
