// system compatibility
import android.os.Build

fun getDeviceInfo(): String {
    return "Device: ${Build.MANUFACTURER} ${Build.MODEL}, " +
           "Android version: ${Build.VERSION.RELEASE}, " +
           "API level: ${Build.VERSION.SDK_INT}"
}

fun isTablet(context: Context): Boolean {
    return context.resources.configuration.screenLayout and 
           Configuration.SCREENLAYOUT_SIZE_MASK >= 
           Configuration.SCREENLAYOUT_SIZE_LARGE
}

fun getDeviceType(context: Context): String {
    return when {
        isTablet(context) -> "Tablet"
        Build.VERSION.SDK_INT >= Build.VERSION_CODES.WATCH -> {
            if (context.packageManager.hasSystemFeature(PackageManager.FEATURE_WATCH)) "Smartwatch" else "Phone"
        }
        else -> "Phone"
    }
}