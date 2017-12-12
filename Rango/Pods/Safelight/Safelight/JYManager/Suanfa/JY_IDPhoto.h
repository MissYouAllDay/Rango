#ifndef _JY_IDPHOTO_
#define _JY_IDPHOTO_

#ifdef   __cplusplus
extern "C"{
#endif

/**
 * 初始化
 *
 * @param data [I] 数据文件
 * @return 成功返回0，失败返回非0
 */
    int   JY_IDPhoto_Init(void const * data);


/**
 * 单人照人脸检测
 *
 * @param _src [I] 图像数据
 * @param _width [I] 图像宽度
 * @param _height [I] 图像高度
 * @return 返回人脸数目
 */
    int  JY_IDPhoto_FaceLoc(const unsigned char *_src,const int _width,const int _height);


/**
 * 单人照获取预裁剪区域
 *
 * @param area [O] 预裁剪区域在原图中的坐标（left为area[0],top为area[1],right为area[2],bottom为area[3]）

 * @return 成功返回0,失败返回非0
 */
    int  JY_IDPhoto_GetArea(int area[]);


/**
 * 单人照设置图像
 *
 * @param _src[I] 预裁剪图像数据
 * @param _width[I] 预裁剪图像宽度
 * @param _height[I] 预裁剪图像高度
 * @return 成功返回0,失败返回非0
 */
    int   JY_IDPhoto_SetImg(const unsigned char *_src,const int _width,const int _height);

/**
 * 单人照环境判断
 *
 * @param pose[O] 头部摆正（0～100）
 * @param dim[O] 光照充足（0～100）
 * @param twoFace[O] 阴阳脸（0～100）
 * @param bfSim[O] 服装突出（0～100）
 * @return 成功返回0,失败返回非0
 */
    int   JY_IDPhoto_EnvJudge(int* pose,int* dim, int* twoFace,int* bfSim);


/**
 * 结婚照人脸检测
 *
 * @param _src [I] 图像数据
 * @param _width [I] 图像宽度
 * @param _height [I] 图像高度
 * @return 返回人脸数目
 */
    int  JY_IDPhoto_FaceLocMrg(const unsigned char *_src,const int _width,const int _height);
	

/**
 * 结婚照获取预裁剪区域
 *
 * @param areaMrg [O] 预裁剪区域(两人合并框)在原图中的坐标（left为areaMrg[0],top为areaMrg[1],right为areaMrg[2],bottom为areaMrg[3]）
 * @param areaLeftPerson [O] 左边人在原图中的坐标（left为areaLeftPerson[0],top为areaLeftPerson[1],right为areaLeftPerson[2],bottom为areaLeftPerson[3]）
 * @param areaRightPerson [O] 左边人在原图中的坐标（left为areaRightPerson[0],top为areaRightPerson[1],right为areaRightPerson[2],bottom为areaRightPerson[3]）
 * @return 成功返回0,失败返回非0
 **/
    int  JY_IDPhoto_AreaMrg(int areaMrg[],int areaLeftPerson[],int areaRightPerson[]);

/**
 * 结婚照设置图像
 *
 * @param _src[I] 预裁剪（两人合并框）图像数据
 * @param _width[I] 预裁剪（两人合并框）图像宽度
 * @param _height[I] 预裁剪（两人合并框）图像高度
 * @return 成功返回0,失败返回非0
 **/
    int  JY_IDPhoto_SetImgMrg(const unsigned char *_src,const int _width,const int _height);

/**
 * 结婚照环境判断
 *
 * @param dim[O] 光照充足（0～100）
 * @param twoFace[O] 阴阳脸（0～100）
 * @param bfSim[O] 服装突出（0～100）
 * @param heightDiff[O] 身高差（0～100）
 * @param distanceDiff[O] 距离差（0～100）
 * @return 成功返回0,失败返回非0
 */
    int  JY_IDPhoto_Judge_EnvMrg(int* dim,int* twoFace,int* bfSim, int* heightDiff,int* distanceDiff);

/**
 * 释放
  * @return 成功返回0,失败返回非0
 */
    int   JY_IDPhoto_Free();


#ifdef   __cplusplus
};
#endif   /*JY_IDPHOTO*/

#endif  