package com.zdy_flutter.wxapi;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.chrone.chpaysdk.net.UrlConstant;
import com.chrone.chpaysdk.util.AppUtil;
import com.tencent.mm.sdk.constants.ConstantsAPI;
import com.tencent.mm.sdk.modelbase.BaseReq;
import com.tencent.mm.sdk.modelbase.BaseResp;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.IWXAPIEventHandler;
import com.tencent.mm.sdk.openapi.WXAPIFactory;

public class WXPayEntryActivity extends Activity implements IWXAPIEventHandler {

    private static final String TAG = "MicroMsg.SDKSample.WXPayEntryActivity";

    private IWXAPI api;

    private RelativeLayout mLayout;

    private TextView tvOrderNo, tvOrderTime, tvMoney;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        api = WXAPIFactory.createWXAPI(this, UrlConstant.app_id);
        api.handleIntent(getIntent(), this);
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        setIntent(intent);
        api.handleIntent(intent, this);
    }

    @Override
    public void onReq(BaseReq req) {
    }

    @Override
    public void onResp(BaseResp resp) {
        Log.d(TAG, "onPayFinish, errCode = " + resp.errCode);

        if (resp.getType() == ConstantsAPI.COMMAND_PAY_BY_WX) {
            String paycode = "-1";
            if (0 == resp.errCode) {
                Log.d("wxpay", "支付成功");
                paycode = "0";
                if (UrlConstant.callback != null) {
                    UrlConstant.callback.dlPayResult(paycode);
                }
                if (UrlConstant.mactivity != null) {
                    if (!UrlConstant.mactivity.isFinishing()) {
                        UrlConstant.mactivity.finish();
                    }
                }
            } else if (-2 == resp.errCode) {
                Log.d("wxpay", "取消支付");
                paycode = "1";
                UrlConstant.wxcallback.wxCancel();

                return;
            } else {
                Log.d("wxpay", "支付失败");
                paycode = "-1";
                if (UrlConstant.callback != null) {
                    UrlConstant.callback.dlPayResult(paycode);
                }
                if (UrlConstant.mactivity != null) {
                    if (!UrlConstant.mactivity.isFinishing()) {
                        UrlConstant.mactivity.finish();
                    }
                }

            }

            WXPayEntryActivity.this.finish();
        }

    }
}