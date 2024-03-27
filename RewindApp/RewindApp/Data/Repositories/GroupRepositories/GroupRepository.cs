using Microsoft.EntityFrameworkCore;
using RewindApp.Controllers.GroupControllers;
using RewindApp.Controllers.UserControllers;
using RewindApp.Entities;
using RewindApp.Interfaces.GroupInterfaces;
using RewindApp.Requests;
using RewindApp.Responses;
using RewindApp.Views;

namespace RewindApp.Data.Repositories.GroupRepositories;

public class GroupRepository : IGroupRepository
{
    private readonly DataContext _context;
    private readonly GroupsController _groupsController;

    public GroupRepository(DataContext context)
    {
        _context = context;
        _groupsController = new GroupsController(context);
    }
    
    public async Task<IEnumerable<Group>> GetGroupsAsync()
    {
        return await _context.Groups.ToListAsync();
    }

    public async Task<IEnumerable<Group>> GetGroupsByUserAsync(int userId)
    {
        var users = await _context.Users
            .Include(user => user.Groups)
            .ToListAsync();

        return users
            .Where(user => user.Id == userId)
            .SelectMany(user => user.Groups)
            .ToList();
    }

    public async Task<IEnumerable<User>> GetUsersByGroupAsync(int groupId)
    {
        var groups = await _context.Groups
            .Include(group => group.Users)
            .ToListAsync();

        return groups
            .Where(group => group.Id == groupId)
            .SelectMany(group => group.Users)
            .ToList();
    }

    public async Task<IEnumerable<Media>> GetMediaByGroupIdAsync(int groupId)
    {
        var groups = await _context.Groups
            .Include(g => g.Media)
            .ToListAsync();

        return groups
            .Where(g => g.Id == groupId)
            .SelectMany(g => g.Media)
            .ToList();
    }

    public async Task<Group?> CreateGroupAsync(User owner, CreateGroupRequest request)
    {
        var group = new Group
        {
            OwnerId = owner.Id,
            Name = request.GroupName,
            Image = Array.Empty<byte>()
        };
        
        group.Users.Add(owner);
        owner.Groups.Add(group);
        _context.Groups.Add(group);

        await _context.SaveChangesAsync();

        return group;
    }

    public async Task<User> AddUserToGroupAsync(Group group, User user, int groupId, int userId)
    {
        group.Users.Add(user);
        user.Groups.Add(group);
        await _context.SaveChangesAsync();

        return user;
    }

    public async Task<User> DeleteUserFromGroupAsync(Group group, User user, IEnumerable<Group> groups, IEnumerable<User> users, int groupId, int userId)
    {
        var newUsers = users.ToList();
        newUsers.Remove(user);
        group.Users = newUsers;
        _context.Groups.Update(group);
        
        //if (groups == null) return BadRequest("No groups found");
        
        var newGroups = groups.ToList();
        newGroups.Remove(group);
        user.Groups = newGroups;
        _context.Users.Update(user);
        
        await _context.SaveChangesAsync();

        return user;
    }

    public async Task<Group> DeleteGroupAsync(Group group, int groupId)
    {
        _context.Groups.Remove(group);
        await _context.SaveChangesAsync();

        return group;
    }

    public async Task<Group?> GetGroupByIdAsync(int groupId)
    {
        return await _context.Groups.Include(group => group.Media).FirstOrDefaultAsync(g => g.Id == groupId);
    }
}