namespace RewindApp.Domain.Requests.MediaRequests;

public class TagsRequest
{
    public ICollection<string> Tags { get; set; } = new List<string>();
}