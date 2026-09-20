package com.example.mutqin

import android.Manifest
import android.content.pm.PackageManager
import android.media.AudioFormat
import android.media.AudioRecord
import android.media.MediaRecorder
import android.os.Bundle
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import kotlin.concurrent.thread

class MainActivity : FlutterActivity() {

    companion object {
        private const val METHOD_CHANNEL =
            "com.mutqin.audio/microphone"

        private const val EVENT_CHANNEL =
            "com.mutqin.audio/microphone_stream"

        private const val REQUEST_RECORD_AUDIO = 1001

        private const val SAMPLE_RATE = 16000

        private const val CHANNEL_COUNT =
            AudioFormat.CHANNEL_IN_MONO

        private const val AUDIO_FORMAT =
            AudioFormat.ENCODING_PCM_16BIT
    }

    private var audioRecord: AudioRecord? = null

    @Volatile
    private var isRecording = false

    private var eventSink: EventChannel.EventSink? = null

    override fun configureFlutterEngine(
        flutterEngine: FlutterEngine
    ) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            METHOD_CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {
                "requestPermission" -> {
                    if (hasMicrophonePermission()) {
                        result.success(true)
                    } else {
                        requestMicrophonePermission()
                        result.success(false)
                    }
                }

                "startRecording" -> {
                    startRecording(result)
                }

                "stopRecording" -> {
                    stopRecording()
                    result.success(null)
                }

                else -> {
                    result.notImplemented()
                }
            }
        }

        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            EVENT_CHANNEL
        ).setStreamHandler(
            object : EventChannel.StreamHandler {

                override fun onListen(
                    arguments: Any?,
                    events: EventChannel.EventSink?
                ) {
                    eventSink = events
                }

                override fun onCancel(
                    arguments: Any?
                ) {
                    eventSink = null
                }
            }
        )
    }

    private fun hasMicrophonePermission(): Boolean {
        return ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.RECORD_AUDIO
        ) == PackageManager.PERMISSION_GRANTED
    }

    private fun requestMicrophonePermission() {
        ActivityCompat.requestPermissions(
            this,
            arrayOf(Manifest.permission.RECORD_AUDIO),
            REQUEST_RECORD_AUDIO
        )
    }

    private fun startRecording(
        result: MethodChannel.Result
    ) {
        if (!hasMicrophonePermission()) {
            requestMicrophonePermission()

            result.error(
                "PERMISSION_REQUIRED",
                "يجب السماح للتطبيق باستخدام الميكروفون.",
                null
            )

            return
        }

        if (isRecording) {
            result.success(null)
            return
        }

        val minimumBufferSize =
            AudioRecord.getMinBufferSize(
                SAMPLE_RATE,
                CHANNEL_COUNT,
                AUDIO_FORMAT
            )

        if (minimumBufferSize <= 0) {
            result.error(
                "AUDIO_CONFIG_ERROR",
                "تعذر إعداد الميكروفون.",
                null
            )
            return
        }

        val bufferSize =
            maxOf(
                minimumBufferSize * 2,
                4096
            )

        try {
            audioRecord = AudioRecord(
                MediaRecorder.AudioSource.MIC,
                SAMPLE_RATE,
                CHANNEL_COUNT,
                AUDIO_FORMAT,
                bufferSize
            )

            if (
                audioRecord?.state !=
                AudioRecord.STATE_INITIALIZED
            ) {
                audioRecord?.release()
                audioRecord = null

                result.error(
                    "AUDIO_INIT_ERROR",
                    "تعذر تهيئة الميكروفون.",
                    null
                )
                return
            }

            audioRecord?.startRecording()

            if (
                audioRecord?.recordingState !=
                AudioRecord.RECORDSTATE_RECORDING
            ) {
                audioRecord?.release()
                audioRecord = null

                result.error(
                    "AUDIO_RECORDING_ERROR",
                    "تعذر بدء التقاط الصوت.",
                    null
                )
                return
            }

            isRecording = true

            thread(
                start = true,
                name = "MutqinAudioRecorder"
            ) {
                readAudioLoop(bufferSize)
            }

            result.success(null)

        } catch (error: Exception) {
            isRecording = false

            try {
                audioRecord?.release()
            } catch (_: Exception) {
            }

            audioRecord = null

            result.error(
                "AUDIO_START_ERROR",
                error.message ?: "تعذر بدء التسجيل.",
                null
            )
        }
    }

    private fun readAudioLoop(
        bufferSize: Int
    ) {
        val buffer = ByteArray(bufferSize)

        while (isRecording) {
            val record = audioRecord ?: break

            val bytesRead = try {
                record.read(
                    buffer,
                    0,
                    buffer.size
                )
            } catch (_: Exception) {
                break
            }

            if (bytesRead > 0) {
                val data = buffer.copyOf(bytesRead)

                runOnUiThread {
                    if (isRecording) {
                        eventSink?.success(data)
                    }
                }
            }
        }
    }

    private fun stopRecording() {
        isRecording = false

        try {
            audioRecord?.stop()
        } catch (_: Exception) {
        }

        try {
            audioRecord?.release()
        } catch (_: Exception) {
        }

        audioRecord = null
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(
            requestCode,
            permissions,
            grantResults
        )
    }

    override fun onDestroy() {
        stopRecording()
        super.onDestroy()
    }
}
