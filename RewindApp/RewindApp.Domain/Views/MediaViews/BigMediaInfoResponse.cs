namespace RewindApp.Domain.Views.MediaViews;

public class BigMediaInfoResponse
{
    public int Id { get; set; } 
    public byte[] Object { get; set; } = Array.Empty<byte>();
    public UserView? Author { get; set; }
    public DateTime Date { get; set; }
    public bool Liked { get; set; }
}