//
//  ViewController.h
//  AcronymFinder
//
//  Created by Swathi Mallela on 1/25/16.
//  Copyright (c) 2016 Swathi Mallela. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *enterAcronymTextField;
@property (weak, nonatomic) IBOutlet UITextView *displayAcronymMeaningView;
@property (strong, nonatomic) NSMutableArray *acronymMeanings;

@end

