package com.example.scanbot_sdk_example_flutter

import android.annotation.SuppressLint
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.provider.Settings.Secure
import android.graphics.SurfaceTexture
import android.hardware.camera2.CameraCharacteristics.SCALER_STREAM_CONFIGURATION_MAP
import android.hardware.camera2.CameraCharacteristics.SENSOR_ORIENTATION
import android.hardware.camera2.CameraManager
import android.media.Image
import android.media.ImageReader
import android.media.MediaRecorder
import android.os.BatteryManager
import android.os.Build
import android.os.Bundle
import android.os.PersistableBundle
import android.provider.MediaStore
import android.provider.Settings
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import java.nio.ByteBuffer
import java.util.concurrent.TimeUnit


class MainActivity: FlutterActivity() {
    private val channel = "template_workspace";

    fun fromByteBuffer(buffer: ByteBuffer): Bitmap? {
        val bytes = ByteArray(buffer.capacity())
        buffer[bytes, 0, bytes.size]
        return BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger, channel
        ).setMethodCallHandler{
            call,result ->
            if(call.method == "get_battery_status"){
                val batteryLevel = getBatteryLevel()
                if (batteryLevel != -1) {
                    result.success(batteryLevel)
                } else {
                    result.error("UNAVAILABLE", "Battery level not available.", null)
                }
            }else if(call.method == "get_unique_id"){
                val deviceUniqueId = getAndroidId();
                result.success(deviceUniqueId)
            }else if(call.method == "open_camera") {
                openCamera()
                result.success("Camera opened successfully")
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getAndroidId(): String {
        val contentResolver = applicationContext.contentResolver
        return Secure.getString(contentResolver, Secure.ANDROID_ID) ?: ""
    }

    private fun openCamera() {
        GlobalScope.launch {
            val reader:ImageReader.OnImageAvailableListener = ImageReader.OnImageAvailableListener {
                val tag = "READER"
                val captureTag = "IMAGE_READED"
                try {
                    val image:Image = it.acquireLatestImage()
                    val buffer = image.planes[0].buffer
                    val bitmap: Bitmap = fromByteBuffer(buffer)!!

                    Log.d(captureTag, bitmap.toString())
                    image.close()
                }catch (error: Exception){
                    Log.d(tag, error.message.toString())
                }
            }
        }
        val cameraIntent = Intent(MediaStore.ACTION_IMAGE_CAPTURE)
        startActivity(cameraIntent)
        // Implement your camera opening logic here
        // For example, you can start a new activity to open the camera
//        val intent = Intent(this, YourCameraActivity::class.java)
//        startActivity(intent)
    }
    private fun getBatteryLevel(): Int {
        val batteryLevel: Int
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
            batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        } else {
            val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(
                Intent.ACTION_BATTERY_CHANGED))
            batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
        }

        return batteryLevel
    }

//    @SuppressLint("MissingPermission")
//    private fun openCamera(width: Int, height: Int) {
//        if (!hasPermissionsGranted(VIDEO_PERMISSIONS)) {
//            requestVideoPermissions()
//            return
//        }
//
//        val cameraActivity = activity
//        if (cameraActivity == null || cameraActivity.isFinishing) return
//
//        val manager = cameraActivity.getSystemService(Context.CAMERA_SERVICE) as CameraManager
//        try {
//            if (!cameraOpenCloseLock.tryAcquire(2500, TimeUnit.MILLISECONDS)) {
//                throw RuntimeException("Time out waiting to lock camera opening.")
//            }
//            val cameraId = manager.cameraIdList[0]
//
//            // Choose the sizes for camera preview and video recording
//            val characteristics = manager.getCameraCharacteristics(cameraId)
//            val map = characteristics.get(SCALER_STREAM_CONFIGURATION_MAP) ?:
//            throw RuntimeException("Cannot get available preview/video sizes")
//            sensorOrientation = characteristics.get(SENSOR_ORIENTATION)
//            videoSize = chooseVideoSize(map.getOutputSizes(MediaRecorder::class.java))
//            previewSize = chooseOptimalSize(map.getOutputSizes(SurfaceTexture::class.java),
//                width, height, videoSize)
//
//            if (resources.configuration.orientation == Configuration.ORIENTATION_LANDSCAPE) {
//                textureView.setAspectRatio(previewSize.width, previewSize.height)
//            } else {
//                textureView.setAspectRatio(previewSize.height, previewSize.width)
//            }
//            configureTransform(width, height)
//            mediaRecorder = MediaRecorder()
//            manager.openCamera(cameraId, stateCallback, null)
//        } catch (e: CameraAccessException) {
//            showToast("Cannot access the camera.")
//            cameraActivity.finish()
//        } catch (e: NullPointerException) {
//            // Currently an NPE is thrown when the Camera2API is used but not supported on the
//            // device this code runs.
//            ErrorDialog.newInstance(getString(R.string.camera_error))
//                .show(childFragmentManager, FRAGMENT_DIALOG)
//        } catch (e: InterruptedException) {
//            throw RuntimeException("Interrupted while trying to lock camera opening.")
//        }
//    }
//
//    /**
//     * Close the [CameraDevice].
//     */
//    private fun closeCamera() {
//        try {
//            cameraOpenCloseLock.acquire()
//            closePreviewSession()
//            cameraDevice?.close()
//            cameraDevice = null
//            mediaRecorder?.release()
//            mediaRecorder = null
//        } catch (e: InterruptedException) {
//            throw RuntimeException("Interrupted while trying to lock camera closing.", e)
//        } finally {
//            cameraOpenCloseLock.release()
//        }
//    }
}

