package com.zdy_flutter;

import com.chrone.chpaysdk.dao.CHOrder;
import com.chrone.chpaysdk.encryutil.MD5Util;
import com.chrone.chpaysdk.encryutil.StringUtil;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.util.Arrays;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

/**
 * 服务端签名工具类
 *
 * @author Jerry.Zhang
 *
 */
public class SdkSignatureUtil {

	/**
	 * 验签
	 *
	 *            :商户密钥
	 * @param order
	 *            :订单信息
	 * @return
	 */
	public static boolean check(String appSecret, CHOrder order) {
		if (null == order || StringUtil.isEmpty(order.getSignature())) {
			return false;
		}
		String signature = order.getSignature();
		String localSign = doSign(appSecret, order);
		return signature.equalsIgnoreCase(localSign);
	}

	/**
	 * 根据订单信息算签名
	 *
	 * @param order
	 * @return
	 */
	public static String doSign(String appSecret, CHOrder order) {
		Map<String, String> map = new HashMap<String, String>();
		Method[] methods = CHOrder.class.getMethods();
		for (Method method : methods) {
			String methodName = method.getName();
			if (methodName.startsWith("get") && !methodName.equals("getClass")) {
				try {
					Object object = method.invoke(order, new Object[]{});
					if (object != null
							&& !StringUtil.isEmpty(object.toString())
							&& !"getSignature".equals(methodName)) {
						String field = methodName.substring(3);
						map.put(field.substring(0, 1).toLowerCase()+field.substring(1), object.toString());
					}
				} catch (IllegalArgumentException e) {
					e.printStackTrace();
				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				}
			}
		}
		return doEncrypt(map, appSecret);
	}

	private static String doEncrypt(Map<String, String> map, String mchntKey) {
		Object[] keys = map.keySet().toArray();
		Arrays.sort(keys);
		StringBuilder originStr = new StringBuilder();
		for (Object key : keys) {
			originStr.append(key).append("=").append(map.get(key)).append("&");
		}
		originStr.append("key=").append(mchntKey);
		// String sign =
		// DigestUtils.md5DigestAsHex(originStr.toString().getBytes());
		return MD5Util.MD5String(originStr.toString());
	}

	public static String getIPAddress(final boolean useIPv4) {
		try {
			for (Enumeration<NetworkInterface> nis = NetworkInterface.getNetworkInterfaces(); nis.hasMoreElements(); ) {
				NetworkInterface ni = nis.nextElement();
				// 防止小米手机返回10.0.2.15
				if (!ni.isUp()) continue;
				for (Enumeration<InetAddress> addresses = ni.getInetAddresses(); addresses.hasMoreElements(); ) {
					InetAddress inetAddress = addresses.nextElement();
					if (!inetAddress.isLoopbackAddress()) {
						String hostAddress = inetAddress.getHostAddress();
						boolean isIPv4 = hostAddress.indexOf(':') < 0;
						if (useIPv4) {
							if (isIPv4) return hostAddress;
						} else {
							if (!isIPv4) {
								int index = hostAddress.indexOf('%');
								return index < 0 ? hostAddress.toUpperCase() : hostAddress.substring(0, index).toUpperCase();
							}
						}
					}
				}
			}
		} catch (SocketException e) {
			e.printStackTrace();
		}
		return null;
	}

}
