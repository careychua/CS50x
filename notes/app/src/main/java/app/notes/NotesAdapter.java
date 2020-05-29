package app.notes;

import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;
import java.util.List;

public class NotesAdapter extends RecyclerView.Adapter<NotesAdapter.NoteViewHolder> {
    // Start: class NoteViewHolder
    public static class NoteViewHolder extends RecyclerView.ViewHolder {
        // declare variables
        LinearLayout containerView;
        TextView textView;

        // Start: constructor
        NoteViewHolder(View view) {
            super(view);

            // instantiate by getting references from view
            containerView = view.findViewById(R.id.note_row);
            textView = view.findViewById(R.id.note_row_text);

            containerView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Note current = (Note) containerView.getTag();
                    Intent intent = new Intent(v.getContext(), NoteActivity.class);
                    intent.putExtra("id", current.id);
                    intent.putExtra("contents", current.contents);

                    v.getContext().startActivity(intent);
                }
            });
        }
        // End: constructor
    }
    // End: class NoteViewHolder


    // declare variables
    private List<Note> notes = new ArrayList<>();

    // Start: onCreateViewHolder()
    @NonNull
    @Override
    public NoteViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.note_row, parent, false);

        return new NoteViewHolder(view);
    }
    // Start: onCreateViewHolder()


    // Start: onBindViewHolder()
    @Override
    public void onBindViewHolder(@NonNull NoteViewHolder holder, int position) {
        // get note using position
        Note current = notes.get(position);
        holder.textView.setText(current.contents);
        holder.containerView.setTag(current);
    }
    // Start: onBindViewHolder()


    // Start: getItemCount()
    @Override
    public int getItemCount() {
        return notes.size();
    }
    // Start: getItemCount()


    // Start: reload()
        // reload database into view
    public void reload() {
        notes = MainActivity.database.noteDao().getAllNotes();
        notifyDataSetChanged();
    }
    // End: reload()
}