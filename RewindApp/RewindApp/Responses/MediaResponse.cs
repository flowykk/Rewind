using RewindApp.Entities;

namespace RewindApp.Responses;

public class MediaResponse
{
    public int PageNumber { get; set; }
    public int PageSize { get; set; }
    public List<Media> Media { get; set; } = new List<Media>();
}