//
//  ViewController.m
//  AcronymFinder
//
//  Created by Swathi Mallela on 1/25/16.
//  Copyright (c) 2016 Swathi Mallela. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h" 
#import "MBProgressHUD.h"

static NSString * const kBaseURLString = @"http://www.nactem.ac.uk/software/acromine/dictionary.py";

@interface ViewController ()

@end

@implementation ViewController


#pragma mark - View Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //intitialize
    self.enterAcronymTextField.text = @"";
    self.displayAcronymMeaningView.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)findAcronymMeaning:(id)sender {
    if(self.enterAcronymTextField.text && ![self.enterAcronymTextField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Retrieving meanings...";
        [self getMeanings];
    }
}


- (IBAction)clearTextField:(id)sender {
    
    self.enterAcronymTextField.text = @"";
    self.displayAcronymMeaningView.text = @"";
    
}

#pragma mark - Service

- (void) getMeanings {
    
    NSString *urlString = [NSString stringWithFormat:@"%@?sf=%@", kBaseURLString, self.enterAcronymTextField.text]; // the json keys to be specified in constant file
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    AFJSONResponseSerializer *jsonResponseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableSet *jsonAcceptableContentTypes = [NSMutableSet setWithSet:jsonResponseSerializer.acceptableContentTypes];
    [jsonAcceptableContentTypes addObject:@"text/plain"]; //This is needed because server is returning text/plain content type instead of json
    jsonResponseSerializer.acceptableContentTypes = jsonAcceptableContentTypes;
    operation.responseSerializer = jsonResponseSerializer;
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSArray *responseData = (NSArray *)responseObject;
        if([responseData count]) {
            self.displayAcronymMeaningView.text = [self prepareAcronymMeaningsListFromLongForms:[[responseData objectAtIndex:0] objectForKey:@"lfs"]]; //TODO: the json keys to be specified in constant file
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Not found"
                                                                message:@"Acronym meaning unavailable."
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil]; //TODO: remove hard coding of the message
            [alertView show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Meanings"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil]; //TODO: remove hard coding of the message
        [alertView show];
    }];
    
    [operation start];
}

#pragma mark - Misc

- (NSString *) prepareAcronymMeaningsListFromLongForms:(NSArray *)longFormList {
    
    NSMutableArray *fullForms = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *eachLongForm in longFormList) {
        [fullForms addObject:[eachLongForm objectForKey:@"lf"]]; //TODO: the json keys to be specified in constant file
    }
    
    return [fullForms componentsJoinedByString:@"\n"];
}


@end
