package com.sdk;

import java.io.Serializable;

public class NETDEV_DISCOVERY_DEVINFO_S implements Serializable {
    private static final long serialVersionUID = 1L;

    public String    szDevAddr;                            /* 设备地址  Device address */
    public String    szDevModule;                          /* 设备型号  Device model */
    public String    szDevSerailNum;                       /* 设备序列号  Device serial number */
    public String    szDevMac;                             /* 设备MAC地址  Device MAC address */
    public String    szDevName;                            /* 设备名称  Device name */
    public String    szDevVersion;                         /* 设备版本  Device version */
    public int       enDevType;                             /* 设备类型  Device type NETDEV_DEVICE_TYPE_E */
    public int       dwDevPort;                             /* 设备端口号  Device port number */
    public String    szManuFacturer;                       /* 生产商 Device manufacture */
    public String    szActiveCode;                         /* 激活码 activeCode */
    public String    szCloudUserName;                       /* 云用户名称 cloudUserName */
}
