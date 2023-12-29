package mb.sdk_camera_android.uniview

data class UniviewResponse (
    var status: ResponseStatus = ResponseStatus.FAILURE,
    var value: Any? = null
)

enum class ResponseStatus(val value: Int) {
    SUCCESS(0),
    FAILURE(1);

    companion object {
        private val map = ResponseStatus.values().associateBy { it.value }
        infix fun fromValue(value: Int) = map[value]
    }

}