using RewindApp.Views;

namespace RewindApp.Responses;

public class GroupInfoResponse
{
    public int Id { get; set; }
    public int DataSize { get; set; }
    public string Name { get; set; }
    public byte[] Image { get; set; }
    public UserView Owner { get; set; }
    public IEnumerable<UserView>? FirstMembers { get; set; }
    public int GallerySize { get; set; }
    public IEnumerable<MediaView>? FirstMedia { get; set; }
}