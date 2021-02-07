package com.example.Destiny2Toolbox

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import androidx.annotation.NonNull

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    var code : String? = null
    val CHANNEL_NAME = "com.example.Destiny2Toolbox"
    val VIEW_URL_METHOD = "openUrl"
    val AUTH_CALLBACK = "handleAuthCode"
    var channel : MethodChannel? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        code = intent.data?.getQueryParameter("code")
    }

    override fun onNewIntent(intent: Intent) {
        code = intent.data?.getQueryParameter("code")
        channel?.invokeMethod(AUTH_CALLBACK, code)
    }

    override fun configureFlutterEngine(@NonNull engine : FlutterEngine) {
        super.configureFlutterEngine(engine)
        channel = MethodChannel(engine.dartExecutor.binaryMessenger, CHANNEL_NAME)
        channel?.setMethodCallHandler {
            call, result -> 
                if(call.method == VIEW_URL_METHOD) {
                    val url : String? = call.argument("url");
                    var intent : Intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
                    startActivity(intent)
                    result.success(code)
                } else {
                    result.notImplemented()
                }
        }
    }
}
