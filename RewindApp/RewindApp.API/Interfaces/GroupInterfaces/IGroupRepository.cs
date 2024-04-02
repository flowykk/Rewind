using RewindApp.Entities;
using RewindApp.Requests;
using RewindApp.Responses;

namespace RewindApp.Interfaces.GroupInterfaces;

public interface IGroupRepository
{
     Task<IEnumerable<Group>> GetGroupsAsync();
     Task<IEnumerable<Group>> GetGroupsByUserAsync(int userId);
     Task<IEnumerable<User>> GetUsersByGroupAsync(int groupId);
     Task<IEnumerable<Media>> GetMediaByGroupIdAsync(int groupId);
     Task<Group?> CreateGroupAsync(User owner, CreateGroupRequest request);
     Task<User> AddUserToGroupAsync(Group group, User user, int groupId, int userId);

     Task<User> DeleteUserFromGroupAsync(Group group, User user, IEnumerable<Group> groups, IEnumerable<User> users,
          int groupId, int userId);
     Task<Group> DeleteGroupAsync(Group group, int groupId);
     Task<Group?> GetGroupByIdAsync(int groupId);
}