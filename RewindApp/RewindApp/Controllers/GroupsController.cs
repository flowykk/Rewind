using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RewindApp.Data;
using RewindApp.Entities;
using RewindApp.RequestsModels;

namespace RewindApp.Controllers;

[ApiController]
[Route("[controller]")]
public class GroupsController : ControllerBase
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

    [HttpPost("create")]
    public async Task<ActionResult> CreateGroup(CreateGroupRequest request)
    {
        if (_context.Groups.Any(group => group.OwnerId == request.OwnerId && group.GroupName == request.GroupName))
        {
            return BadRequest($"Group with this name, created by User {request.OwnerId} already exists!");
        }

        var group = new Group
        {
            OwnerId = request.OwnerId,
            GroupName = request.GroupName,
            GroupImage = Array.Empty<byte>()
        };

        var owner = _usersController.GetUserById(request.OwnerId).Result;
        if (owner == null) return BadRequest("No user with such ownerId");

        group.Users.Add(owner);
        owner.Groups.Add(group);
        //group.Users = new List<User> { owner };
        //owner.Groups = new List<Group> { group };
        _context.Groups.Add(group);

        await _context.SaveChangesAsync();

        return Ok("Group was created successfully!");
    }

    [HttpDelete("delete/{groupId}")]
    public async Task<ActionResult> DeleteGroup(int groupId)
    {
        var group = GetGroupById(groupId);
        if (group == null) return BadRequest("No group with such Id");

        _context.Groups.Remove(group);
        await _context.SaveChangesAsync();

        return Ok($"Group was deleted successfully! {group.Users.Count}");
        return Ok($"Group was deleted successfully! {group.Users.Count} {_usersController.GetUserById(group.OwnerId).Result.UserName} {_usersController.GetUserById(group.OwnerId).Result.Groups.Count} {group.GroupsId} {group.GroupName}");
    }
    
    public Group? GetGroupById(int groupId)
    {
        var group = _context.Groups.FirstOrDefaultAsync(group => group.GroupsId == groupId).Result;
        return group;
    }
}