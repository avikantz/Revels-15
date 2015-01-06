//
//  PageContentViewController.m
//  Revels'15
//
//  Created by Shubham Sorte on 30/12/14.
//  Copyright (c) 2014 LUGManipal. All rights reserved.
//

#import "PageContentViewController.h"
#import "EventTableViewCell.h"
#import "SSJSONModel.h"
#import "Event.h"
#import "MBProgressHUD.h"

@interface PageContentViewController () <SSJSONModelDelegate>
{
    UITableView * myTableView;
    SSJSONModel * jsonReq;
    NSMutableArray * mainArray;
    MBProgressHUD * hud;
}

@end

@implementation PageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, self.view.frame.size.height)];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    
    self.view.backgroundColor = [UIColor grayColor];
    myTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:myTableView];
    myTableView.contentInset = UIEdgeInsetsMake(64, 0, 35, 0);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    jsonReq = [[SSJSONModel alloc]initWithDelegate:self];
    [jsonReq sendRequestWithUrl:[NSURL URLWithString:@"http://mitrevels.in/api/events/"]];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading";
    hud.dimBackground = YES;
}

-(void)jsonRequestDidCompleteWithDict:(NSArray *)dict model:(SSJSONModel *)JSONModel
{
    if (JSONModel == jsonReq) {
        mainArray = [NSMutableArray array];
        for(NSDictionary *dict in [jsonReq.parsedJsonData objectForKey:@"data"]) {
            Event *event = [[Event alloc] initWithDict:dict];
            [mainArray addObject:event];
        }
        [myTableView reloadData];
        [hud hide:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        [self willScrollToTop];
    }
}

-(void)willScrollToTop
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark- Table View Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mainArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"Cell";
    
    EventTableViewCell * cell = (EventTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"EventCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    Event *event = [mainArray objectAtIndex:indexPath.row];
    cell.eventLocationLabel.text = event.location;
    cell.eventNameLabel.text = event.event;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * blankView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    blankView.backgroundColor = [UIColor clearColor];
    return blankView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
@end
