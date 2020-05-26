package app.notes;

public class print {

    print(Object ... objectArray) {
        for (Object object : objectArray) {
            System.out.print(object + " ");
        }
        System.out.println("");
    }
}
