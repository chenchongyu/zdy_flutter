package com.zdy_flutter;

import android.app.Activity;
import android.util.Log;

import java.util.concurrent.TimeUnit;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.reactivex.Observable;
import io.reactivex.Observer;
import io.reactivex.disposables.Disposable;

public class FlutterPluginCounter implements EventChannel.StreamHandler {

    public static String ORDER_NO = "";
    public static boolean bOkF = false;
    public static String CHANNEL = "com.zdy/plugin";

    static EventChannel channel;
    private Observable<Long> mObservable;

    private Activity activity;

//    static BasicMessageChannel basicMessageChannel;

    private FlutterPluginCounter(Activity activity) {
        this.activity = activity;
    }

    public static void registerWith(PluginRegistry.Registrar registrar) {
        channel = new EventChannel(registrar.messenger(), CHANNEL);
        FlutterPluginCounter instance = new FlutterPluginCounter(registrar.activity());
        channel.setStreamHandler(instance);
        // basicMessageChannel = new BasicMessageChannel<String> ("foo", StringCodec.INSTANCE);
    }

    @Override
    public void onListen(Object o, final EventChannel.EventSink eventSink) {
        mObservable = Observable.interval(1000, TimeUnit.MILLISECONDS);
        mObservable.observeOn(AndroidScheduler.mainThread())
                .takeUntil(bOk -> {
                    Log.i("FlutterPluginCounter", "订单号" + ORDER_NO);
                    boolean b = !"".equals(ORDER_NO);
                    if (b) {
                        bOkF =  true;
                        ORDER_NO = "";
                    }
                    return b;
                }).subscribe(new Observer<Long>() {
            @Override
            public void onSubscribe(Disposable d) {
                System.out.println("xieshi1");
            }

            @Override
            public void onNext(Long aLong) {
                System.out.println("xieshi7");
                eventSink.success(ORDER_NO);
            }

            @Override
            public void onError(Throwable e) {
                System.out.println("xieshi3");
                eventSink.error("计时器异常", "异常", e.getMessage());
            }

            @Override
            public void onComplete() {
                System.out.println("xieshi4");
                ORDER_NO = "";
            }
        });

    }

    @Override
    public void onCancel(Object o) {
        Log.i("FlutterPluginCounter", "FlutterPluginCounter:onCancel");
        Log.i("FlutterPluginCounter", "是否完成订单" + bOkF);
        ORDER_NO = "123";
        if (bOkF) {
            ORDER_NO = "";
        }
        bOkF = false;
        Log.i("FlutterPluginCounter", "订单号" + ORDER_NO);
    }

}