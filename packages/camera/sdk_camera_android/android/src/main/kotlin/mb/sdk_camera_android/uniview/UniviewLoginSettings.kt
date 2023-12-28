data class UniviewLoginSettings(
    val ip: String,
    val port: Int,
    val userName: String,
    val password: String,
    val extra: Map<String, Any?>
)