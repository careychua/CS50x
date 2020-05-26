package app.notes;

import androidx.room.ColumnInfo;
import androidx.room.Entity;
import androidx.room.PrimaryKey;

// specifies the class represents a table in the database
    // this will create a table called notes with 2 columns, PrimaryKey and contents
@Entity(tableName = "notes")
public class Note {
    // declare properties
        // add annotations provided by Room library
    // specifies using PrimaryKey of database
    @PrimaryKey
    public int id;
    // species its a column in the database
    @ColumnInfo(name = "contents")
    public String contents;
}
