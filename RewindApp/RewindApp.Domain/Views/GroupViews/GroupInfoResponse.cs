using RewindApp.Domain.Views.MediaViews;

namespace RewindApp.Domain.Views.GroupViews;

public class GroupInfoResponse
{
    public int Id { get; set; }
    public int DataSize { get; set; }
    public string Name { get; set; } = string.Empty;
    public byte[] Image { get; set; } = Array.Empty<byte>();
    public int GallerySize { get; set; }
    public UserView Owner { get; set; } = new();
    public IEnumerable<UserView>? FirstMembers { get; set; }
    public IEnumerable<MediaView>? FirstMedia { get; set; }
}