namespace RewindApp.Requests.MediaRequests;

public class LoadMediaRequest
{
    public string Object { get; set; } = string.Empty;
    public string TinyObject { get; set; } = string.Empty;
    public int IsPhoto { get; set; }
    public ICollection<string> Tags { get; set; } 
}