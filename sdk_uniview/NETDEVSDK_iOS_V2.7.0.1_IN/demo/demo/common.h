//
//  common.h
//  demo
//
//  Created by on 8/20/19.
//  Copyright © 2019. All rights reserved.
//

#ifndef common_h
#define common_h

#define NETDEMO_MAX_DEVICES                       512               //Max device number

//login type
typedef enum tagNETDEMODEVLogType
{
    NETDEMO_LOGTYPE_UNKNOW = -1,
    NETDEMO_LOGTYPE_LOCAL,
}NETDEMO_DEV_LOGIN_TYPE;

typedef struct tagNETDEMO_LOGIN_INFO_S
{
    NETDEMO_DEV_LOGIN_TYPE   dwLoginType;
    
    CHAR    szUserName[NETDEV_USERNAME_LEN];
    CHAR    szPassword[NETDEV_PASSWORD_LEN];
    CHAR    szIPAddr[NETDEV_MAX_URL_LEN];
    INT32   dwPort;
    INT32   dwDevType;
    INT32   dwLoginProto;
    
} NETDEMO_LOGIN_INFO_S, *LPNETDEMO_LOGIN_INFO_S;

typedef struct tagNETDEMO_DEVICE_INFO_S
{
    INT32 dwChnNum;
    INT32 dwDevIndex;
    NETDEV_DEV_BASIC_INFO_S stDevBasicInfo;
    NETDEV_DEV_CHN_ENCODE_INFO_S vecChanInfo[NETDEV_LEN_512];

}NETDEMO_DEVICE_INFO_S, *LPNETDEMO_DEVICE_INFO_S;

typedef struct tagNETDEV_DEV_LOGININFO_S
{
    NETDEMO_LOGIN_INFO_S stNETDEV_LoginInfo;
    
    LPVOID    pHandle;
    INT32    dwDevNum;
    NETDEMO_DEVICE_INFO_S stDevLoginInfo[NETDEMO_MAX_DEVICES];
}NETDEMO_DEV_LOGININFO_S, *LPNETDEMO_DEV_LOGININFO_S;

#endif /* common_h */
