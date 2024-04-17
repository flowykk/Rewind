using RewindApp.Domain.Views.GroupViews;
using RewindApp.Domain.Views.MediaViews;

namespace RewindApp.Domain.Responses;

public class RewindScreenDataResponse
{
    public IEnumerable<GroupView>? Groups { get; set; }
    public BigMediaInfoResponse? RandomImage { get; set; }
    public int GallerySize { get; set; } = 0;
}