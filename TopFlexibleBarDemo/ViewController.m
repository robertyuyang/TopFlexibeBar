//
//  ViewController.m
//  TopFlexibleBarDemo
//
//  Created by Robert Yu on 29/09/2017.
//  Copyright © 2017 Robert Yu. All rights reserved.
//

#import "ViewController.h"
#import "TopFiexibleBar.h"


@interface ViewController ()

@property (nonatomic, strong) UISearchBar* seachBar;
@property (nonatomic, strong) UIWebView* webView;
@property (nonatomic, strong) TopFiexibleBar* topBar;


@end

static const CGFloat kSegmentedHeight = 50;
@implementation ViewController

- (void)OnNotification:(NSNotification*)notification{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.seachBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kSegmentedHeight)];
    self.seachBar.delegate = self;
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL: [NSURL URLWithString:@"https://www.sogou.com"]]];
    
    self.topBar = [[TopFiexibleBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kSegmentedHeight)] ;
    [self.view addSubview:self.topBar];
    [self.topBar setScrollView:self.webView.scrollView contentView:self.seachBar];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)createSearchBar {
    
    self.seachBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kSegmentedHeight)];
    self.seachBar.delegate = self;
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL: [NSURL URLWithString:@"https://www.sogou.com"]]];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if([searchBar.text isEqualToString: @"1"]){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        ViewController* vc = [[ViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}


@end
