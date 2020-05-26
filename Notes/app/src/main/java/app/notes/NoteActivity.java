package app.notes;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.view.View;
import android.widget.EditText;

public class NoteActivity extends AppCompatActivity {
    //declare fields
    private EditText editText;
    private int id;

    // Start: onCreate()
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_note);

        // instantiate by referencing field in view
        editText = findViewById(R.id.note_edit_text);

        // use intent to get contents from Main Activity
        String contents = getIntent().getStringExtra("contents");
        id = getIntent().getIntExtra("id", 0);
        editText.setText(contents);
    }
    // End: onCreate()

    // Start: save()
    public void save(View view) {
        String contents = editText.getText().toString();
        MainActivity.database.noteDao().save(contents, id);
        finish();
    }
    // End: save()


    // Start: delete()
    public void delete(View view) {
        System.out.println("in delete()");
        MainActivity.database.noteDao().delete(id);
        finish();
    }
    // End: delete()
}
