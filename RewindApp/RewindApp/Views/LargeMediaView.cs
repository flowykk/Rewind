using RewindApp.Entities;

namespace RewindApp.Views;

public class LargeMediaView
{
    public int Id { get; set; } 
    public byte[] Object { get; set; } = Array.Empty<byte>();
    public UserView? Author { get; set; }
    public DateTime Date { get; set; }
    public bool Liked { get; set; }
}