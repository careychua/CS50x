package app.notes;

import androidx.room.Dao;
import androidx.room.Query;

import java.util.List;

// interface, annotate with queries
    // Room library will generate the classes
@Dao
public interface NoteDao {
    @Query("INSERT INTO notes (contents) VALUES ('new note')")
    void create();

    @Query("SELECT * FROM notes")
    List<Note> getAllNotes();

    // use parameter binding to put values into query
    @Query("UPDATE notes SET contents = :contents WHERE id = :id")
    void save(String contents, int id);

    @Query("DELETE FROM notes WHERE id = :id")
    void delete(int id);
}
