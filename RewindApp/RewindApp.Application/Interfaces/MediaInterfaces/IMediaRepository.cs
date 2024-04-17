using RewindApp.Domain.Entities;
using RewindApp.Domain.Requests.MediaRequests;
using RewindApp.Domain.Views.MediaViews;

namespace RewindApp.Application.Interfaces.MediaInterfaces;

public interface IMediaRepository
{
    Task<IEnumerable<Media>> GetMediaAsync();
    Task<Media?> GetMediaByIdAsync(int mediaId);
    Task<LargeMediaInfoResponse> GetMediaInfoByIdAsync(Media media, int userId);
    Task LikeMediaAsync(Media media, User user);
    Task UnlikeMediaAsync(Media media, User user);
    Task<int> LoadMediaToGroupAsync(LoadMediaRequest mediaRequest, int groupId, int authorId);
    Task UnloadMediaFromGroupAsync(Media media, Group group);
}