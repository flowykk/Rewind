using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RewindApp.Controllers.UserControllers;
using RewindApp.Data;
using RewindApp.Entities;
using RewindApp.RequestsModels;

namespace RewindApp.Controllers.GroupControllers;

public interface IGroupsController
{
    public Task<Group?> GetGroupById(int groupId);
}

[ApiController]
[Route("[controller]")]
public class GroupsController : ControllerBase, IGroupsController
{
    private readonly DataContext _context;
    private readonly ILogger<GroupsController> _logger;
    private readonly IUsersController _usersController;

    public GroupsController(DataContext context, ILogger<GroupsController> logger, IUsersController usersController)
    {
        _context = context;
        _logger = logger;
        _usersController = usersController;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<Group>>> GetGroups()
    {
        return await _context.Groups.ToListAsync();
    }
    
    [HttpGet("{userId}")]
    public async Task<IEnumerable<Group>> GetGroupsByUser(int userId)
    {
        var users = await _context.Users
            .Include(user => user.Groups)
            .ToListAsync();

        return users
            .Where(user => user.Id == userId)
            .SelectMany(user => user.Groups)
            .ToList();
    }
    
    [HttpGet("image/{groupId}")]
    public async Task<ActionResult<byte[]>> GetGroupImage(int groupId)
    {
        var group = await GetGroupById(groupId);
        if (group == null) return BadRequest("Group not found");

        return group.Image;
    }
    
    [HttpGet("users/{groupId}")]
    public async Task<IEnumerable<User>> GetUsersByGroup(int groupId)
    {
        var groups = await _context.Groups
            .Include(group => group.Users)
            .ToListAsync();

        return groups
            .Where(group => group.Id == groupId)
            .SelectMany(group => group.Users)
            .ToList();
    }

    [HttpGet("media/{groupId}")]
    public async Task<ActionResult<IEnumerable<Media>>> GetMediaByGroupId(int groupId)
    {
        var group = await GetGroupById(groupId);
        if (group == null) return BadRequest("Group not found");
        
        return group.Media.ToList();
    }
    
    [HttpPost("create")]
    public async Task<ActionResult> CreateGroup(CreateGroupRequest request)
    {
        if (_context.Groups.Any(group => group.OwnerId == request.OwnerId && group.Name == request.GroupName))
        {
            return BadRequest($"Group with this name, created by User {request.OwnerId} already exists!");
        }

        var group = new Group
        {
            OwnerId = request.OwnerId,
            Name = request.GroupName,
            Image = Array.Empty<byte>()
        };

        var owner = _usersController.GetUserById(request.OwnerId).Result;
        if (owner == null) return BadRequest($"No user with Id {request.OwnerId}");

        group.Users.Add(owner);
        owner.Groups.Add(group);
        _context.Groups.Add(group);

        await _context.SaveChangesAsync();

        return Ok("Group was created successfully!");
    }

    [HttpPost("add/{groupId}/{userId}")]
    public async Task<ActionResult> AddUserToGroup(int groupId, int userId)
    {
        var group = await GetGroupById(groupId);
        if (group == null) return BadRequest($"No group with Id {groupId}");
        if (GetGroupsByUser(userId).Result.ToList().Contains(group)) 
            return BadRequest($"Group {groupId} already contains User {userId}");

        var user = await _usersController.GetUserById(userId);
        if (user == null) return BadRequest($"No user with Id {userId}");

        group.Users.Add(user);
        user.Groups.Add(group);
        await _context.SaveChangesAsync();

        return Ok($"User {userId} was successfully added to group {groupId} {group.Users.Count}");
    }

    [HttpPut("delete/{groupId}/{userId}")]
    public async Task<ActionResult> DeleteUserFromGroup(int groupId, int userId)
    {
        var group = await GetGroupById(groupId);
        if (group == null) return BadRequest($"No group with Id {groupId}");

        var user = await _usersController.GetUserById(userId);
        if (user == null) return BadRequest($"No user with Id {userId}");
        
        /*group.Users.Remove(user);
        _context.Groups.Update(group);
        
        user.Groups.Remove(group);
        _context.Users.Update(user);
        
        await _context.SaveChangesAsync();*/

        var newUsers = GetUsersByGroup(groupId).Result.ToList();
        newUsers.Remove(user);
        group.Users = newUsers;
        _context.Groups.Update(group);
        
        var newGroups = GetGroupsByUser(userId).Result.ToList();
        newGroups.Remove(group);
        user.Groups = newGroups;
        _context.Users.Update(user);
        
        await _context.SaveChangesAsync();

        return Ok($"{user.Groups.Count} {group.Users.Count} User {userId} was successfully removed from group {groupId}");
    }

    [HttpDelete("delete/{groupId}")]
    public async Task<ActionResult> DeleteGroup(int groupId)
    {
        var group = await GetGroupById(groupId);
        if (group == null) return BadRequest($"No group with Id {groupId}");

        _context.Groups.Remove(group);
        await _context.SaveChangesAsync();

        return Ok($"Group was deleted successfully! {group.Users.Count}");
    }
    
    public Task<Group?> GetGroupById(int groupId)
    {
        var group = _context.Groups.Include(group => group.Media).FirstOrDefaultAsync(g => g.Id == groupId);
        return group;
    }
}