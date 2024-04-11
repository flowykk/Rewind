using RewindApp.Domain.Entities;
using RewindApp.Domain.Requests;
using RewindApp.Domain.Responses;
using RewindApp.Domain.Views;
using RewindApp.Domain.Views.GroupViews;
using RewindApp.Domain.Views.MediaViews;

namespace RewindApp.Application.Interfaces.GroupInterfaces;

public interface IGroupRepository
{
    Task<IEnumerable<Group>> GetGroupsAsync();
    Task<BigMediaInfoResponse?> GetRandomMediaAsync(int groupId, int userId, bool images, bool quotes, bool onlyFavorites);
    Task<GroupInfoResponse?> GetGroupInfoAsync(Group group, int userId, int dataSize);
    SmallGroupInfoResponse GetSmallGroupInfo(Group group);
    Task<RewindScreenDataResponse> GetInitialRewindScreenDataAsync(int groupId, int userId);
    Task<IEnumerable<GroupView>> GetGroupViewsByUserAsync(int userId);
    Task<IEnumerable<Group>> GetGroupsByUserAsync(int userId);
    Task<IEnumerable<UserView>> GetUserViewsByGroupAsync(int groupId);
    Task<IEnumerable<User>> GetUsersByGroupAsync(int groupId);
    Task<IEnumerable<MediaView>> GetMediaByGroupAsync(int groupId, int mediaId);
    Task<int> CreateGroupAsync(User owner, CreateGroupRequest request);
    Task<SmallGroupInfoResponse> AddUserToGroupAsync(Group group, User user);
    Task DeleteUserFromGroupAsync(Group group, User user);
    Task DeleteGroupAsync(Group group);
    Task<Group?> GetGroupByIdAsync(int groupId);
    
    Task<IEnumerable<BigMediaInfoResponse>> GetBigMediaByGroupAsync(FilterSettings filterSettings, int groupId, int userId);
    Task<BigMediaInfoResponse?> GetRandomBigMediaAsync(FilterSettings filterSettings, int groupId, int userId);
}