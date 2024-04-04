namespace RewindApp.Domain.Views.GroupViews;

public class GroupView
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public int? OwnerId { get; set; }
    public byte[] TinyImage { get; set; }
    public int GallerySize { get; set; }
}