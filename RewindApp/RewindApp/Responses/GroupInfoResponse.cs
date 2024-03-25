using RewindApp.Entities;

namespace RewindApp.Responses;

public class GroupInfoResponse
{
    public int Id { get; set; }
    public int DataSize { get; set; }
    public string Name { get; set; }
    public byte[] Image { get; set; }
    public User Owner { get; set; }
    public List<User> FirstMembers { get; set; }
    public int GallerySize { get; set; }
    public List<Media> FirstMedia { get; set; }
}