using RewindApp.Domain.Entities;

namespace RewindApp.Domain.Views.MediaViews;

public class LargeMediaInfoResponse
{
    public int Id { get; set; } 
    public byte[] Object { get; set; } = Array.Empty<byte>();
    public UserView? Author { get; set; }
    public DateTime Date { get; set; }
    public bool Liked { get; set; }
    public ICollection<Tag> Tags { get; set; } = new List<Tag>();
}