function mood()
{
    var moods = ["normal", "stuck", "done", "happy"];
    var mood_select = document.getElementById("mood_select").value;
    console.log("mood_select: "+mood_select);
    console.log("moods.length: "+moods.length);
    for (let i = 0; i < moods.length; i++)
    {
        console.log("i: "+i);
        img = document.getElementById(moods[i]);
        if (mood_select == moods[i])
        {
            console.log(moods[i] + "visible");
            img.style.display = "inline";
        }
        else
        {
            console.log(moods[i] + "hidden");
            img.style.display = "none";
        }
    }
}