package app.pokedex;

import java.io.Serializable;

// object to store name and number of pokemon
public class Pokemon implements Serializable {
    private String name;
    private String url;
    private Boolean caught;

    // constructor
    Pokemon(String name, String url, Boolean caught) {
        this.name = name;
        this.url = url;
        this.caught = caught;
    }

    public String getName() {
        return name;
    }

    public String getUrl() {
        return url;
    }

    public Boolean getCaught() {
        return caught;
    }

    public void setCaught(Boolean status) {
        caught = status;
    }
}
