//
//  Color.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/5/11.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#ifndef Color_h
#define Color_h

//RGB 颜色  带有透明度
//#define RGBColor(r,g,b,alpha) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:alpha]
#define RGBColor(r, g, b,alph) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:alph]

// RGB颜色
#define HWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 随机色
#define ARCColor HWColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#define FONT_COLOR_38 ([UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1])
#define GRAY_126 ([UIColor colorWithRed:126/255.0 green:126/255.0 blue:126/255.0 alpha:1])
#define COLOR_247 ([UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1])
#define COLOR_WHITE ([UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1])

//日历界面 不可点击灰色
#define COLOR_204 ([UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1])


#define COLOR_230 HWColor(230,230,230)  //  线条颜色   线条宽度  0.5   -- 接近于浅灰色
#define COLOR_245 HWColor(245,245,245)  // 背景颜色  --- 接近于白色
#define COLOR_52  HWColor(52,52,52)     // 字体颜色  -- 接近于黑色
#define COLOR_231 HWColor(231,231,231)  // 线框 颜色  --- 浅灰色
#define COLOR_211 HWColor(211,211,211)  // textfile 的placeholdertext  字体颜色
#define COLOR_153 HWColor(153,153,153)  // 字体颜色   暗灰色

//蓝色
#define COLOR_NAVIBAR HWColor(2,167,255)        // 状态栏 蓝色
#define COLOR_FONT_BLUE HWColor(27,176,255)      // 字体 蓝色
#define COLOR_BUTTON_BLUE   HWColor(77,186,244) // 按钮蓝色


#endif /* Color_h */
