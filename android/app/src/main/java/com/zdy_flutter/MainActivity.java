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

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "pay";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        registerSelfPlugin();

        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler() {

            @Override
            public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                Log.i("MethodChannel", "onMethodCall ->" + methodCall.method);
                if (methodCall.method.equals("start_pay")) {
                    String orderId = methodCall.argument("order_id");
                    String price = methodCall.argument("price");
                    try {
                        startPay(orderId, (int) Double.parseDouble(price));
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


    private void registerSelfPlugin() {
        AsrPlugin.registerWith(registrarFor("com.zdy.asr_plugin.asr.AsrPlugin"));
    }


    public void startPay(String orderId, int price) {
        //todo 修改appId、notifyURL、body等
        CHOrder orderInfo = new CHOrder();
        orderInfo.setAmount(price);
        orderInfo.setAppid("0000005028");
        orderInfo.setBody("{\"a\":123}");
        orderInfo.setClientIp("192.168.31.2");
        orderInfo.setMchntOrderNo(orderId);
        orderInfo.setNotifyUrl("http://test.chrone.net/medicine_health_api/notify");
        orderInfo.setSubject("订单");
        orderInfo.setSignature(SdkSignatureUtil.doSign("53702ab28e81e4c23a2977705e67d391",
                orderInfo));

        CHPayManager manager = CHPayManager.getInstance(this);

        manager.startCHPaysdk(orderInfo, new CHCallBack() {

            @Override
            public void payFaile(String str) {
                Toast.makeText(getApplicationContext(), "支付失败->" + str, Toast.LENGTH_SHORT).show();

            }

            @Override
            public void dlPayResult(String payResultCode) {
                Toast.makeText(getApplicationContext(), "支付成功->" + payResultCode, Toast.LENGTH_SHORT).show();
            }
        });

    }
}
