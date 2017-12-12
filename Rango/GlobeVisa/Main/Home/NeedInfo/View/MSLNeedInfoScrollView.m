//
//  MSLNeedInfoScrollView.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/1.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLNeedInfoScrollView.h"
#import "MSLNeedInfoScrollItem.h"
@interface MSLNeedInfoScrollView ()<UIScrollViewDelegate,UIScrollViewDelegate>
{
    UICollectionView *_collectionView;
    NSMutableArray *_offsetArr;
    NSMutableArray *_offsetWidth;
    UIScrollView *_headScroll;
    
    UIImageView *_slideImg; // 滑块
    UIButton *_oldBtn;
    MSLNeedInfoScrollItem *_item;
    
    
    
}
@end
@implementation MSLNeedInfoScrollView

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        
    }
    return self;
}

- (void)setImageArr:(NSMutableArray *)imageArr {
    
    _imageArr = imageArr;
    [self createScroll];
}

- (void)createScroll {
    
    _offsetArr = [[NSMutableArray alloc] init];
    _offsetWidth = [[NSMutableArray alloc] init];
    UIView *btgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, self.heightCX)];
    btgView.backgroundColor = [UIColor whiteColor];
    _headScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(15, 0, WIDTH - 30, btgView.heightCX)];
    _headScroll.tag = 3100;
    [btgView addSubview:_headScroll];
    _headScroll.delegate = self;
    _headScroll.bounces = NO;
    _headScroll.backgroundColor = COLOR_WHITE;
    _headScroll.showsVerticalScrollIndicator = NO;
    _headScroll.showsHorizontalScrollIndicator = NO;

    for (int i = 0; i < _titleArr.count; i ++) {
        
        MSLNeedInfoScrollItem *item = [[[NSBundle mainBundle] loadNibNamed:@"MSLNeedInfoScrollItem" owner:nil options:nil] lastObject];
        item.frame = CGRectMake(i * (375 - 60)/4, 0, (375 - 60)/4, btgView.heightCX);
        item.img.image = [UIImage imageNamed:_imageArr[i]];
        item.name.text = _titleArr[i];
        item.name.font = FONT_SIZE_11;
        item.markView.tag = 3000 + i;
        item.name.textColor = HWColor(204, 204, 204);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [item.markView addGestureRecognizer:tap];
       
        if ([_titleArr[i] isEqualToString: @"在职人员"]) {
            
            _item = item;
            _item.name.font = FONT_SIZE_13;
            _item.name.textColor = COLOR_FONT_BLUE;
            _item.img.image = [UIImage imageNamed:[NSString  stringWithFormat:@"%@1",_imageArr[i]]];
        }
        [_headScroll addSubview:item];
    }
    //底部分割线
    UIView *downLine =  [[UIView alloc] initWithFrame:CGRectMake(0, _headScroll.heightCX - 0.5, WIDTH,0.5)];
    downLine.backgroundColor = COLOR_230;
    [btgView addSubview:downLine];
    _headScroll.contentSize = CGSizeMake(_titleArr.count *(375 - 40)/4 , _headScroll.heightCX);
    
    // 滑块
    _slideImg = [[UIImageView alloc] initWithFrame:CGRectMake(_item.leftCX, _headScroll.heightCX - 3, _item.widthCX, 3)];
    [_headScroll addSubview:_slideImg];
    _slideImg.contentMode = UIViewContentModeBottom;
    _slideImg.image = [UIImage imageNamed:@"message_label"];
    [self addSubview:btgView];
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    
    UIView *mark = tap.view;
    if (mark.tag == _item.markView.tag) {
        return;
    }
    MSLNeedInfoScrollItem *item = (MSLNeedInfoScrollItem *)mark.superview.superview.superview;
    NSInteger index = mark.tag - 3000;
    [self.delegate needInfoScrollViewSelectIndex:index];

    item.img.image = [UIImage imageNamed:[NSString  stringWithFormat:@"%@1",_imageArr[index]]];
    item.name.textColor = COLOR_FONT_BLUE;
    item.name.font = FONT_SIZE_13;
    
    _item.img.image = [UIImage imageNamed:[NSString  stringWithFormat:@"%@",_imageArr[_item.markView.tag - 3000]]];
    _item.name.textColor = HWColor(204, 204, 204);
    _item.name.font = FONT_SIZE_11;
    
    _item = item;
    
    [UIView animateWithDuration:0.35 animations:^{
        _slideImg.leftCX = item.leftCX;
        _slideImg.rightCX = item.rightCX;
        _slideImg.widthCX = item.widthCX;
    }];
}
//缩放结束
-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    
    if (scrollView.tag == _item.scroll.tag || scrollView.tag == 3100) {
        return;
    }
    MSLNeedInfoScrollItem *item = (MSLNeedInfoScrollItem *)scrollView.superview;
    NSInteger index = scrollView.tag - 3000;
    item.img.image = [UIImage imageNamed:[NSString  stringWithFormat:@"%@1",_imageArr[index]]];
    item.name.textColor = COLOR_FONT_BLUE;
    item.name.font = FONT_SIZE_13;
    if (_item) {
        _item.img.image = [UIImage imageNamed:[NSString  stringWithFormat:@"%@1",_imageArr[_item.scroll.tag - 3000]]];
        _item.name.textColor = [UIColor blackColor];
        _item.name.font = FONT_SIZE_11;
        _item.scroll.zoomScale = 1.0;
    }
    
}

- (UIView *)createCollectionView {
    
    _offsetArr = [[NSMutableArray alloc] init];
    _offsetWidth = [[NSMutableArray alloc] init];
    UIView *btgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, self.heightCX)];
    btgView.backgroundColor = [UIColor whiteColor];
    _headScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(15, 0, WIDTH - 30, btgView.heightCX)];
    [btgView addSubview:_headScroll];
    _headScroll.delegate = self;
    _headScroll.bounces = NO;
    _headScroll.backgroundColor = COLOR_WHITE;
    _headScroll.showsVerticalScrollIndicator = NO;
    _headScroll.showsHorizontalScrollIndicator = NO;
    
    BOOL havaSelect = NO;
    for (int i = 0; i < _titleArr.count; i ++) {
        NSString *title = @"在职人员";
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * (375 - 60)/4, 0, (375 - 60)/4, btgView.heightCX);
        [_headScroll addSubview:btn];

        [btn addTarget:self action:@selector(personTypeAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 1300 + i;
        btn.titleLabel.font = FONT_SIZE_11;
        
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:_imageArr[i]] forState:UIControlStateNormal];
        [btn setTitleColor:HWColor(204, 204, 204) forState:UIControlStateNormal];
        [self  changeBtn:btn];

        
        if ([_titleArr[i] isEqualToString: @"在职人员"]) {
            
            havaSelect = YES;
            [btn setImage:[UIImage imageNamed:[NSString  stringWithFormat:@"%@1",_imageArr[btn.tag - 1300]]] forState:UIControlStateNormal];
            [btn setTitleColor:COLOR_FONT_BLUE forState:UIControlStateNormal];
            _oldBtn = btn;
            [self  changeBtn:_oldBtn];

        }
    }
    
    //底部分割线
    UIView *downLine =  [[UIView alloc] initWithFrame:CGRectMake(0, _headScroll.heightCX - 0.5, WIDTH,0.5)];
    downLine.backgroundColor = COLOR_230;
    [btgView addSubview:downLine];
    _headScroll.contentSize = CGSizeMake(_titleArr.count *(375 - 40)/4 , _headScroll.heightCX);
    
    // 滑块
    _slideImg = [[UIImageView alloc] initWithFrame:CGRectMake(_oldBtn.leftCX, _headScroll.heightCX - 3, _oldBtn.widthCX, 3)];
    [_headScroll addSubview:_slideImg];
    _slideImg.contentMode = UIViewContentModeBottom;
    _slideImg.image = [UIImage imageNamed:@"message_label"];
    
    return btgView;
}

- (void)setSelectIndex:(int)selectIndex {
    
    _selectIndex = selectIndex;
    
    UIButton *sender = [self viewWithTag:_selectIndex + 1300];
    [self personTypeAction:sender];
    
}
//人员那类型点击事件   对滑块  底层scroll做滑动
- (void)personTypeAction:(UIButton *)sender {
    
    if (_oldBtn == sender) {  return; }
    
    NSInteger index = sender.tag - 1300;
    [self.delegate needInfoScrollViewSelectIndex:index];
    // 还原
    _oldBtn.titleLabel.font = FONT_SIZE_11;
    [_oldBtn setImage:[UIImage imageNamed:[NSString  stringWithFormat:@"%@",_imageArr[_oldBtn.tag - 1300]]] forState:UIControlStateNormal];
    [_oldBtn setTitleColor:HWColor(204, 204, 204) forState:UIControlStateNormal];
    _oldBtn.selected = NO;
    
    [sender setImage:[UIImage imageNamed:[NSString  stringWithFormat:@"%@1",_imageArr[index]]] forState:UIControlStateNormal];
    [sender setTitleColor:COLOR_FONT_BLUE forState:UIControlStateNormal];

    [self changeBtn:_oldBtn];
    [self changeBtn:sender];
    _oldBtn = sender;

    [UIView animateWithDuration:0.35 animations:^{

        _slideImg.leftCX = sender.leftCX;
        _slideImg.rightCX = sender.rightCX;
        _slideImg.widthCX = sender.widthCX;
    }];
}

- (void)changeBtn:(UIButton *)sender {
    
    CGSize imgViewSize,titleSize,btnSize;
    UIEdgeInsets imageViewEdge,titleEdge;
    CGFloat heightSpace = 10.0f;
    sender.titleLabel.font = FONT_SIZE_13;
    imgViewSize = sender.imageView.bounds.size;
    titleSize = sender.titleLabel.bounds.size;
    btnSize = sender.bounds.size;
    imageViewEdge = UIEdgeInsetsMake(heightSpace,0.0, btnSize.height -imgViewSize.height - heightSpace, - titleSize.width);
    [sender setImageEdgeInsets:imageViewEdge];
    titleEdge = UIEdgeInsetsMake(imgViewSize.height + heightSpace, - imgViewSize.width, 0.0, 0.0);
    [sender setTitleEdgeInsets:titleEdge];
}
@end
