package com.zdy_flutter;

import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

import com.chrone.chpaysdk.activity.CHPayManager;
import com.chrone.chpaysdk.callback.CHCallBack;
import com.chrone.chpaysdk.dao.CHOrder;
import com.zdy.asr_plugin.asr.AsrPlugin;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.PluginRegistry;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "pay";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        registerSelfPlugin(this);

        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler() {

            @Override
            public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                Log.i("MethodChannel", "onMethodCall ->" + methodCall.method);
                if (methodCall.method.equals("start_pay")) {
                    Log.i("MethodChannel", "xieshi");
                    String orderId = methodCall.argument("order_id");
                    Log.i("MethodChannel", "order_id ->" + orderId);
                    int price = methodCall.argument("price");
                    Log.i("MethodChannel", "price ->" + price);
                    try {
                        String sResult = startPay(orderId, price);
                        result.success(sResult);
                    } catch (NumberFormatException e) {
                        e.printStackTrace();
                        Log.i("MethodChannel", "onMethodCall ->" + e);
                    }
//                    if (batteryLevel != -1) {
//                        result.success(batteryLevel);
//                    } else {
//                        result.error("UNAVAILABLE", "Battery level not available.", null);
//                    }
                } else {
                    result.notImplemented();
                }
            }
        });
    }


    private void registerSelfPlugin(PluginRegistry registrar) {
        AsrPlugin.registerWith(registrarFor("com.zdy.asr_plugin.asr.AsrPlugin"));
        FlutterPluginCounter.registerWith(registrar.registrarFor(FlutterPluginCounter.CHANNEL));
    }


    public String startPay(String orderId, int price) {
        //todo 修改appId、notifyURL、body等
        CHOrder orderInfo = new CHOrder();
        orderInfo.setAmount(price);
        orderInfo.setAppid("0000005040");
        orderInfo.setBody("{\"a\":123}");
        orderInfo.setClientIp("192.168.31.2");
        orderInfo.setMchntOrderNo(orderId);
        orderInfo.setNotifyUrl("http://sjzx-kshzj-zhdy-1.cintcm.ac.cn:8080/admin/otc/orderReslut/");
        orderInfo.setSubject("订单");
        orderInfo.setSignature(SdkSignatureUtil.doSign("6f5cc1ab7818f4f303676b188050e8c7",
                orderInfo));
        String sResult = "";
        CHPayManager manager = CHPayManager.getInstance(this);

        manager.startCHPaysdk(orderInfo, new CHCallBack() {

            @Override
            public void payFaile(String str) {
                Toast.makeText(getApplicationContext(), "支付失败->" + str, Toast.LENGTH_SHORT).show();
            }

            @Override
            public void dlPayResult(String payResultCode) {
                if ("1".equals(payResultCode)) {
                    Toast.makeText(getApplicationContext(), "支付取消", Toast.LENGTH_SHORT).show();
                }
            }
        });
        return sResult;
    }
}
