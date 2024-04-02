using RewindApp.Views.GroupViews;
using RewindApp.Views.MediaViews;

namespace RewindApp.Responses;

public class RewindScreenDataResponse
{
    public IEnumerable<GroupView>? Groups { get; set; }
    public BigMediaInfoResponse? RandomImage { get; set; }
    public int GallerySize { get; set; } = 0;
}