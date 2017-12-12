//
//  CAMBuffer.m
//  junyucamera
//
//  Created by dexter on 14-7-9.
//  Copyright (c) 2014年 junyu. All rights reserved.
//

#import "CAMBuffer.h"
#import "UIImage+RGBAConv.h"

@interface CAMBuffer ()
@property(nonatomic) uint8_t* buf;
@property(nonatomic) int width;
@property(nonatomic) int height;
@end

@implementation CAMBuffer

-(id)init
{
	if(self=[super init])
	{
		_buf=NULL;
		_width=_height=-1;
		
		_tmpSave=NO;
		
		_ext32=NO;
	}
	return self;
}

-(void)dealloc
{
	[self clear];
}
-(void)cap:(CAMBuffer*) src
{
	[self resizeWidth:src.width Height:src.height];
}
-(void)from:(CAMBuffer*) src
{
	[self resizeWidth:src.width Height:src.height];
	memcpy(_buf, src.buf, _width*_height*3);
}
-(void)swap:(CAMBuffer*) src
{
	if(self==src)return;
	
	uint8_t *t=src.buf;src.buf=_buf;_buf=t;
	int i=src.width;src.width=_width;_width=i;
	i=src.height;src.height=_height;_height=i;
	
	BOOL b=src.ext32;src.ext32=_ext32;_ext32=b;
}
-(BOOL)isEmpty
{
	return _buf==NULL;
}

-(void)clear
{
	if(_buf)
	{
		free(_buf);
		_buf=NULL;
	}
}

-(void)save:(NSString *)fname
{
	if(_buf)
	{
		NSData *data=[NSData dataWithBytesNoCopy:_buf length:_width*_height*3 freeWhenDone:NO];
		[data writeToFile:[NSTemporaryDirectory() stringByAppendingPathComponent:fname] atomically:NO];
	}
}
-(void)load:(NSString *)fname
{
	//改成没保存不用恢复自己
	if(_tmpSave)
	{
		_tmpSave=NO;
		
		FILE *fp=fopen([[NSTemporaryDirectory() stringByAppendingPathComponent:fname] UTF8String],"r");
		if(fp)
		{
			[self resizeWidth:_width Height:_height];
			if(_buf)
				fread(_buf,_width*_height*3, 1, fp);
			fclose(fp);
		}
	}
}
-(void)resizeWidth:(int)width Height:(int)height
{
	if((_width!=width || _height!=height || _buf==NULL) &&
	   width!=-1 && height!=-1)
	{
		_width=width;
		_height=height;
		
		_buf=realloc(_buf, _width*_height*(_ext32?4:3));
	}
}

-(void)putBuf:(uint8_t*) newBuf width:(int)w height:(int)h {
    [self resizeWidth:w Height:h];
    memcpy(_buf, newBuf, _width*_height*3);
}

-(void)putImage:(UIImage *)img
{
	//_tmpSave=NO;
	
	int width=img.size.width;
	int height=img.size.height;
	
	[self resizeWidth:width Height:height];
	
	[img getRGBA:_buf alpha:NO];
	
	rgb32_to_rgb24_inplace(_buf,_width*_height);
}
-(UIImage *)getImage
{
	rgb24_to_rgb32_inplace(_buf,_width*_height);
	
	return [UIImage getImageFromRGBA:_buf width:_width height:_height alpha:NO];
}

void rgb32_to_rgb24_inplace(uint8_t * __restrict src, int numPixels)
{
#ifdef __ARM_ARCH_7
	asm volatile("lsr		%1,%1,#3		\n"
				 
				 "mov		r4,%0			\n"
				 "mov		r5,%0			\n"
				 
				 "1:						\n"
				 "vld4.8	{d0-d3},[r4]!	\n"
				 "vst3.8	{d1-d3},[r5]!	\n"
				 "subs		%1,%1,#1		\n"
				 "bne		1b				\n"
				 :
				 :"r"(src),"r"(numPixels)
				 :"r4","r5"
				 );
#else
	uint8_t *dest=src;
	
	for(int i=0;i<numPixels;++i)
	{
		dest[0]=src[1];
		dest[1]=src[2];
		dest[2]=src[3];
		
		dest += 3;
		src += 4;
	}
#endif
}

void rgb24_to_rgb32_inplace(uint8_t * __restrict src, int numPixels)
{
#ifdef __ARM_ARCH_7
	asm volatile("lsr		%1,%1,#3		\n"
				 "mov		r4,#255			\n"
				 "vdup.8	d0,r4			\n"
				 
				 "sub		%1,%1,#1		\n"
				 "mov		r4,#24			\n"
				 "mla		r6,%1,r4,%0		\n"
				 "mov		r4,#32			\n"
				 "mla		r7,%1,r4,%0		\n"
				 "add		%1,%1,#1		\n"
				 
				 "mov		r4,#-24			\n"
				 "mov		r5,#-32			\n"
				 "1:						\n"
				 "vld3.8	{d1-d3},[r6],r4	\n"
				 "vst4.8	{d0-d3},[r7],r5	\n"
				 "subs		%1,%1,#1		\n"
				 "bne		1b				\n"
				 :
				 :"r"(src),"r"(numPixels)
				 :"r4","r5","r6","r7"
				 );
#else
	uint8_t *dest=src+(numPixels-1)*4;
	src+=(numPixels-1)*3;
	
	for(int i=0;i<numPixels;++i)
	{
		dest[0]=0xFF;
		dest[1]=src[0];
		dest[2]=src[1];
		dest[3]=src[2];
		
		dest -= 4;
		src -= 3;
	}
#endif
}

void neon_asm_convert_3(uint8_t * __restrict dest, uint8_t * __restrict src, int numPixels)
{
	
#ifdef __ARM_ARCH_7
	asm volatile("mov         r7,%0            \n"
				 "lsr          %2, %2, #3      \n"
				 "# build the three constants: \n"
				 "mov         r4, #28          \n" // Blue channel multiplier
				 "mov         r5, #151         \n" // Green channel multiplier
				 "mov         r6, #77          \n" // Red channel multiplier
				 "vdup.8      d4, r4           \n"
				 "vdup.8      d5, r5           \n"
				 "vdup.8      d6, r6           \n"
				 "1:                       \n"
				 "# load 8 pixels:             \n"
				 "vld3.8      {d0-d2}, [%1]!   \n"
				 "# do the weight average:     \n"
				 "vmull.u8    q7, d0, d4       \n"
				 "vmlal.u8    q7, d1, d5       \n"
				 "vmlal.u8    q7, d2, d6       \n"
				 "# shift and store:           \n"
				 "vshrn.u16   d7, q7, #8       \n" // Divide q3 by 256 and store in the d7
				 "vst1.8      {d7}, [r7]!      \n"
				 "subs        %2, %2, #1       \n" // Decrement iteration count
				 "bne         1b            \n" // Repeat unil iteration count is not zero
				 :
				 : "r"(dest), "r"(src), "r"(numPixels)
				 : "r4", "r5", "r6", "r7"
				 );
#else
	for(int i=0;i<numPixels;++i)
	{
		*dest=(src[0]*114+src[1]*587+src[2]*299 + 500)/1000;
		
		src  += 3;
		dest ++;
	}
#endif
}

-(uint8_t *)getGray
{
    uint8_t *gray=(uint8_t*)malloc(_width*_height);
    neon_asm_convert_3(gray, _buf, _width*_height);
    return gray;
}

-(uint8_t *)getJYGray
{
    uint8_t *gray=(uint8_t*)malloc(_width*_height);
    neon_asm_convert_3(gray, _buf, _width*_height);
    
    uint8_t* temp = gray;
    for (int i = 0; i < _width*_height; ++i, ++temp) {
        *temp = -1 - *temp;
    }
    return gray;
}
@end
