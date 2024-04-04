namespace RewindApp.Domain.Views.GroupViews;

public class SmallGroupInfoResponse
{
    public int Id { get; set; }
    public string Name { get; set; }
    public int OwnerId { get; set; }
    public byte[] TinyImage { get; set; }
}