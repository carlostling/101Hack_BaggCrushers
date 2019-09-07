import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenUtils {
  static init(BuildContext context){
    ScreenUtil.instance = ScreenUtil(width: 411.42857142857144, height: 822.8571428571429,allowFontScaling: true)..init(context);
  }
  static getWidth(double width){
    return ScreenUtil.getInstance().setWidth(width);
  }
  static getHeight(double height){
    return ScreenUtil.getInstance().setWidth(height);
  }
  static getFontSize(double fontSize){
    return ScreenUtil.getInstance().setSp(fontSize);
  }
  static getPx(double width){
    return ScreenUtil.getInstance().setWidth(width);
  }
  static getPhoneHeight(){
    return ScreenUtil.screenHeight;
  }
  static getPhoneWidth(){
    return ScreenUtil.screenWidth;
  }

static appBarTitleSize(){
  return getWidth(16);
}

static appBarLeadingSize(){
  return getFontSize(25);
}
}