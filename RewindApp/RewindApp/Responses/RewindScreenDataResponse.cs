using RewindApp.Entities;
using RewindApp.Views;

namespace RewindApp.Responses;

public class RewindScreenDataResponse
{
    public IEnumerable<GroupView>? Groups { get; set; }
    public LargeMediaView? RandomImage { get; set; }
    public int GallerySize { get; set; } = 0;
}