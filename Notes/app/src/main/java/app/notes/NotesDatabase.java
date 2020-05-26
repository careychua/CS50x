package app.notes;

import androidx.room.Database;
import androidx.room.RoomDatabase;

// specifies this as entry point for all DAO objects used in this application
@Database(entities = {Note.class}, version = 1)
public abstract class NotesDatabase extends RoomDatabase {
    public abstract NoteDao noteDao();
}
