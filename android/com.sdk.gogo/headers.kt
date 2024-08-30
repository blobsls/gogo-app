// headers

import android.os.Build
import java.util.*

object Headers {
    private const val HEADER_USER_AGENT = "User-Agent"
    private const val HEADER_ACCEPT_LANGUAGE = "Accept-Language"
    private const val HEADER_DEVICE_MODEL = "Device-Model"
    private const val HEADER_OS_VERSION = "OS-Version"
    private const val HEADER_APP_VERSION = "App-Version"

    fun getDefaultHeaders(appVersion: String): Map<String, String> {
        return mapOf(
            HEADER_USER_AGENT to getUserAgent(),
            HEADER_ACCEPT_LANGUAGE to getAcceptLanguage(),
            HEADER_DEVICE_MODEL to getDeviceModel(),
            HEADER_OS_VERSION to getOSVersion(),
            HEADER_APP_VERSION to appVersion
        )
    }

    private fun getUserAgent(): String {
        return "GogoApp/${Build.VERSION.RELEASE} (Android ${Build.VERSION.SDK_INT})"
    }

    private fun getAcceptLanguage(): String {
        return Locale.getDefault().toLanguageTag()
    }

    private fun getDeviceModel(): String {
        return "${Build.MANUFACTURER} ${Build.MODEL}"
    }

    private fun getOSVersion(): String {
        return "Android ${Build.VERSION.RELEASE}"
    }
}
