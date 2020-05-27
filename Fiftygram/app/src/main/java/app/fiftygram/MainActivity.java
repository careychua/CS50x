package app.fiftygram;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.os.FileUtils;
import android.os.ParcelFileDescriptor;
import android.provider.MediaStore;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.MultiTransformation;
import com.bumptech.glide.load.Transformation;
import com.bumptech.glide.request.RequestOptions;

import java.io.File;
import java.io.FileDescriptor;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URI;

import jp.wasabeef.glide.transformations.BlurTransformation;
import jp.wasabeef.glide.transformations.RoundedCornersTransformation;
import jp.wasabeef.glide.transformations.gpu.SepiaFilterTransformation;
import jp.wasabeef.glide.transformations.gpu.SketchFilterTransformation;
import jp.wasabeef.glide.transformations.gpu.ToonFilterTransformation;

public class MainActivity extends AppCompatActivity
        implements ActivityCompat.OnRequestPermissionsResultCallback {
    // Declare and initialise constants
    private static final int REQUEST_OPEN_IMAGE = 1;
    private static final int REQUEST_SAVE_IMAGE = 2;

    // declare variables
    private ImageView imageView;
    private Bitmap image;
    private Bitmap bitmap;
    Uri uri;

    // Start: onCreate()
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // get reference to views
        imageView = findViewById(R.id.image_view);

        // pop-up dialog for user's permission to access image gallery
        requestPermissions(new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, 1);
    }
    // End: onCreate()


    // check result of permission grant
    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);

        for (int i = 0; i < permissions.length; i++){
            System.out.println("Permissions: " + permissions[i] + " " + grantResults[i]);
            if (ContextCompat.checkSelfPermission(this, Manifest.permission.WRITE_EXTERNAL_STORAGE)
                    == PackageManager.PERMISSION_GRANTED) {
                System.out.println("Permission granted");
            }
            else {
                System.out.println("Permission not granted");
            }
        }
    }


    // Start: choosePhoto()
        // use intent to get photo from image gallery built into android
    public void choosePhoto(View view) {
        // Intent will open gallery view to select file
        Intent intent1 = new Intent(Intent.ACTION_OPEN_DOCUMENT);
        // Specify type of file to intent
        // this returns any type of image
        intent1.setType("image/*");

        // requestCode to identify where activity is from
        startActivityForResult(intent1, REQUEST_OPEN_IMAGE);
    }
    // End: choosePhoto()


    // Start: savePhoto()
    // use intent to save photo from imageView to gallery
    public void savePhoto(View view) {
        System.out.println("in savePhoto()");

        BitmapDrawable draw = (BitmapDrawable) imageView.getDrawable();
        bitmap = draw.getBitmap();

        try {
            FileOutputStream outStream = null;
            String path = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
                    .toString();
            File directory = new File(path);
            directory.mkdirs();
            String fileName = String.format("%d.jpg", System.currentTimeMillis());
            File outFile = new File(directory, fileName);

            outStream = new FileOutputStream(outFile);
            bitmap.compress(Bitmap.CompressFormat.JPEG, 100, outStream);
            outStream.flush();
            outStream.close();

            // refresh gallery to view image
            Intent intent = new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE);
            intent.setData(Uri.fromFile(outFile));
            sendBroadcast(intent);
        }
        catch (IOException e) {
            Log.e("savePhoto", "Could not save photo", e);
        }
    }
    // End: savePhoto()


    // Start: apply()
    // apply filter with third party libraries
    public void apply(Transformation<Bitmap> filter1, Transformation<Bitmap> filter2) {
        if (filter2 == null) {
            Glide
                    .with(this)
                    .load(image)
                    .apply(RequestOptions.bitmapTransform(filter1))
                    .into(imageView);
        }
        else {
            Glide
                    .with(this)
                    .load(image)
                    .transform(new MultiTransformation(filter1, filter2))
                    .into(imageView);
        }
    }
    // End: apply()


    // Start: applySepia()
    public void applySepia(View view) {
        apply(new SepiaFilterTransformation(), null);
    }
    // End: applySepia()


    // Start: applyToon()
    public void applyToon(View view) {
        apply(new ToonFilterTransformation(), null);
    }
    // End: applyToon()


    // Start: applySketch()
    public void applySketch(View view) {
        apply(new SketchFilterTransformation(), null);
    }
    // End: applySketch()


    // Start: applyBlurCorner()
    public void applyBlurCorner(View view) {
        apply(new BlurTransformation(10),
                new RoundedCornersTransformation
                        (64, 0, RoundedCornersTransformation.CornerType.ALL));
    }
    // End: applyBlurCorner()



    // Start: onActivityResult()
        // called by system when exit activity
    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        System.out.println("in onActivityResult");
        System.out.println("requestCode: " + requestCode);
        System.out.println("resultCode: " + resultCode);
        System.out.println("data: " + data);
        if (resultCode == Activity.RESULT_OK && data != null) {
            try {
                if (requestCode == REQUEST_OPEN_IMAGE) {
                    System.out.println("in REQUEST_OPEN_IMAGE");
                    // get path to the data retrieved
                    uri = data.getData();
                    // open up the data at that path for reading
                        // getContentResolver can do different file operations
                    ParcelFileDescriptor parcelFileDescriptor =
                            getContentResolver().openFileDescriptor(uri, "r");
                    FileDescriptor fileDescriptor = parcelFileDescriptor.getFileDescriptor();
                    image = BitmapFactory.decodeFileDescriptor(fileDescriptor);

                    parcelFileDescriptor.close();
                    imageView.setImageBitmap(image);
                }
            }
            catch (IOException e) {
                Log.e("Fiftygram", "Image not found", e);
            }
        }
        else {
            Log.e("Fiftygram", "Activity Results not OK");
        }
    }
    // End: onActivityResult()
}
