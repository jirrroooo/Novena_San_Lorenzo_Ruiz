package com.jiro.st_lorenzo_ruiz_novena

import android.os.Bundle
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        // Opt in to edge-to-edge with the AndroidX API (enforced from Android 15,
        // API 35). This avoids the deprecated Window.setStatusBarColor /
        // setNavigationBarColor calls; Flutter pads content with the insets.
        WindowCompat.enableEdgeToEdge(window)
        super.onCreate(savedInstanceState)
    }
}
