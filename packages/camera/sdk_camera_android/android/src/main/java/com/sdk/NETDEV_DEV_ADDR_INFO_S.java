package com.sdk;

import java.io.Serializable;

public class NETDEV_DEV_ADDR_INFO_S implements Serializable {
    private static final long serialVersionUID = 1L;

    public String    szUserName;          /* 用户名 User Name */
    public String    szPassword;          /* 密码 Password */
    public String    szIPv4Address;       /* IPv4的IP地址  IP address of IPv4 */
    public String    szIPv4GateWay;       /* IPv4的网关地址  Gateway of IPv4 */
    public String    szIPv4SubnetMask;    /* IPv4的子网掩码  Subnet mask of IPv4 */
    public String    szDevSerailNum;      /* 设备序列号  Device serial number */
    public String    szDevMac;            /* 设备MAC地址  Device MAC address */
}
