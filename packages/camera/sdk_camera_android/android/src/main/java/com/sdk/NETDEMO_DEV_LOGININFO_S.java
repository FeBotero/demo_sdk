package com.sdk;

/**
 * Created by f06266 on 2019/8/1.
 */

public class NETDEMO_DEV_LOGININFO_S {
    public long    pHandle;
    public int    dwDevNum;
    public NETDEMO_DEVICE_INFO_S[] stDevLoginInfo;

    public NETDEMO_DEV_LOGININFO_S() {
        stDevLoginInfo = new NETDEMO_DEVICE_INFO_S[512];
        for(int i =0; i< 512; i++)
        {
            stDevLoginInfo[i] = new NETDEMO_DEVICE_INFO_S();
        }
    }
}
