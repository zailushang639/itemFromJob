//
//  VCOApi.h
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/5/8.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#ifndef PiaoJinSuo_VCOApi_h
#define PiaoJinSuo_VCOApi_h


//uuid
#define USER_UUID [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_UUID"]
#define Url_APPStore @"http://itunes.apple.com/lookup?id=1035192060" //1035192060
//secret_key
#define Secret_id @"official_app_ios"

//企业
//#define pushKey @"55dd70c3e0f55a0e41001c92"//55c9718ee0f55ac704002d62

//app store
#define pushKey @"55c9718ee0f55ac704002d62"

//测试    
//com.vcooline.pushapp
//#define Secret_key @"1234567890098765"
//#define BaseUrl @"http://new.dev.piaojinsuo.com/gateway/"
//#define BaseDataUrl @"http://new.dev.piaojinsuo.com/"
//
//生产
//com.piaojinsuo.pushapp
//#define Secret_key @"4LylLJ%*i^knOZ9J"
//#define BaseUrl @"https://www.piaojinsuo.com/gateway/"
//#define BaseDataUrl @"https://www.piaojinsuo.com/"

//生产
//com.piaojinsuo.pushapp
#define Secret_key @"4LylLJ%*i^knOZ9J"
#define BaseUrl @"https://www.piaojinsuo.cc/gateway/"
#define BaseDataUrl @"https://www.piaojinsuo.cc/"


//会员网关
#define Url_member @"member?"
//订单网关
#define Url_order @"order?"
//查询网关
#define Url_info @"info?"

#endif
