//
//  CXAlertView.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/8/2.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "CXAlertView.h"

#define kDefaultBtnBackgroundColor RGBColor(0, 0, 0,0.5)
#define kDefaultTableViewHeight 37

@interface CXAlertView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak  ) UIWindow      *keyWindow; /// 当前窗口
@property (nonatomic, strong) UIView        *shadowView; /// 遮罩层
@property (nonatomic, weak  ) UITapGestureRecognizer *tapGesture; ///背景的手势
@property (strong, nonatomic) UIView        *popView;
@property (assign,nonatomic ) CGRect        selfFrame;
/*tableviewPopView*/
@property (strong,nonatomic ) UITableView   *tableView;

@end

@implementation CXAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (!(self = [super initWithFrame:[UIApplication sharedApplication].keyWindow.bounds])) return nil;

    [[UIApplication sharedApplication].keyWindow addSubview:self];
    //    self.alpha = 0.f;
    //    self.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    if(frame.size.height <88) {
        frame.size.height = 88;
        _selfFrame = frame;
    }else {
        _selfFrame = frame;
    }
    _shadowViewBackgroundColor = kDefaultBtnBackgroundColor;
    

    [self initUI];
    [self initPopView];
    [self addSubview:self.popView];
    
    return self;
}


- (void)initUI {
    self.backgroundColor = [UIColor clearColor];
    
    // keyWindow
    _keyWindow = [UIApplication sharedApplication].keyWindow;
    // shadeView
    _shadowView = [[UIView alloc] initWithFrame:_keyWindow.bounds];
    _shadowView.alpha = 0.0;
    _shadowView.backgroundColor = kDefaultBtnBackgroundColor;
    
    [self addSubview:_shadowView];
    [self setShowShade:YES];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenPopView)];
    [_shadowView addGestureRecognizer:tapGesture];
    _tapGesture = tapGesture;
}

- (void)initPopView{
    if(self.popView != nil) {
        self.popView = nil;
    }
    self.popView = [[UIView alloc] init];
    self.popView.backgroundColor = [UIColor whiteColor];
    self.popView.layer.masksToBounds = YES;
    self.popView.layer.cornerRadius = 8;
    [self createTableViewPopView];

}

#pragma mark - 是否展示shadowView
- (void)setShowShade:(BOOL)set {
    if(set) {
        self.shadowView.hidden = NO;
    }else {
        self.shadowView.hidden = YES;
    }
}

- (void)createTableViewPopView {
    
    self.popView.frame = CGRectMake(self.selfFrame.origin.x, self.selfFrame.origin.y, self.selfFrame.size.width, self.selfFrame.size.height);
    [self.popView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.popView.frame.size.width, self.popView.frame.size.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.popView addSubview:self.tableView];
}


#pragma mark - tableView delegate;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tableDataArray count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kDefaultTableViewHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.text= _tableDataArray[indexPath.row];
//    cell.textLabel.textColor = COLOR_ALERTFONT;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return _infoType == CameraType ? 8 :48;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (_infoType == CameraType) {
        
        UIView *view = [UIView new];
        view.backgroundColor = self.backgroundColor;
        return view;
    }
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 245, 48)];
    
    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(1, 1, 245, 38)];
    la.text = _titler;
    la.textAlignment = NSTextAlignmentCenter;
//    la.textColor = FONTCOLOE;
    la.font = FONT_16;
    
    [bg addSubview:la];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39, self.frame.size.width, 0.5)];
//    line.backgroundColor = LINECOLOR;
    [bg addSubview:line];
    
    return  bg;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.popViewDelegate popTableViewDidSelect:indexPath withType:_infoType];
    [self hidenPopView];
    
}
#pragma mark - hidePopView 隐藏popView
/*隐藏*/
- (void)hidenPopView {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.f;
        _shadowView.alpha = 0.f;
        self.popView.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    } completion:^(BOOL finished) {
        [_shadowView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

#pragma mark - showpopView 显示popView
/*弹出*/
- (void)showPopView {

    [UIView animateWithDuration:0.1 animations:^{
        
        _shadowView.alpha = 0.7f;
        self.popView.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            self.popView.transform = CGAffineTransformMakeScale(1.f, 1.f);
        } completion:^(BOOL finished) {
            
        }];
    }];
    
}


@end
