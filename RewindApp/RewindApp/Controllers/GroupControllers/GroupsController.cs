using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RewindApp.Controllers.UserControllers;
using RewindApp.Data;
using RewindApp.Data.Repositories.GroupRepositories;
using RewindApp.Entities;
using RewindApp.Interfaces.GroupInterfaces;
using RewindApp.Requests;
using RewindApp.Responses;
using RewindApp.Views;

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
    private readonly IUsersController _usersController;

    public GroupsController(DataContext context) //, ILogger<GroupsController> logger, IUsersController usersController)
    {
        _context = context;
        _usersController = new UsersController(context);
    }

    [HttpGet]
    public async Task<IEnumerable<Group>> GetGroups()
    {
        return await _context.Groups.ToListAsync();
    }
    
    [HttpGet("random/{groupId}")]
    public async Task<ActionResult<Media>> GetRandomMedia(int groupId)
    {
        if (await GetGroupById(groupId) == null)
            return BadRequest("Group not found");
        
        var mediaEnumerable = await GetMediaByGroupId(groupId);
        var media = mediaEnumerable.Value.ToList();
        if (media.Count == 0) return BadRequest("No media in group");
        
        var randomIndex = new Random().Next(0, media.Count);
        
        return Ok(media[randomIndex]);
    }
    
    [HttpGet("{groupId}/{userId}")]
    public async Task<ActionResult<GroupInfoResponse>> GetGroupInfoById(int groupId, int userId, int dataSize)
    {
        var group = await GetGroupById(groupId);
        if (group == null) return BadRequest("Group not found");

        /*var owner = await _usersController.GetUserById(group.OwnerId);
        if (owner == null) return BadRequest("Owner not found");
        
        var groupMembers = await GetUsersByGroup(groupId);
        var firstMembers = groupMembers.Value!
            .Select(u => new UserView {
                Id = u.Id,
                UserName = u.UserName,
                TinyProfileImage = u.TinyProfileImage
            })
            .Where(u => u.Id != owner.Id && u.Id != userId)
            .Take(dataSize);
            //.ToList();
        
        var groupMedia = await GetMediaByGroupId(groupId);
        var firstMedia = groupMedia.Value!
            .Select(m => new MediaView {
                Id = m.Id,
                TinyObject = m.TinyObject
            })
            .Take(dataSize);
            //.ToList(); 
        
        var resultResponse = new GroupInfoResponse()
        {
            Id = group.Id,
            DataSize = dataSize,
            Name = group.Name,
            Image = group.Image,
            Owner = new UserView {
                Id = owner.Id,
                TinyProfileImage = owner.TinyProfileImage,
                UserName = owner.UserName
            },
            FirstMedia = firstMedia,
            GallerySize = groupMedia.Value?.Count() ?? 0,
            FirstMembers = firstMembers
        };*/

        var resultResponse = await GetGroupInfo(group, groupId, userId, dataSize);
        if (resultResponse == null) return BadRequest("Owner not found");
        
        return Ok(resultResponse);
    }
    
    [HttpGet("{userId}")]
    public async Task<ActionResult<IEnumerable<Group>>> GetGroupsByUser(int userId)
    {
        if (await _usersController.GetUserById(userId) == null)
            return BadRequest("User not found");
        
        var users = await _context.Users
            .Include(user => user.Groups)
            .ToListAsync();

        return users
            .Where(user => user.Id == userId)
            .SelectMany(user => user.Groups)
            .ToList();
    }
    
    [HttpGet("users")]
    public async Task<ActionResult<IEnumerable<UserView>>> GetUsersByGroup(int groupId)
    {
        if (await GetGroupById(groupId) == null)
            return BadRequest("Group not found");
        
        var groups = await _context.Groups
            .Include(group => group.Users)
            .ToListAsync();

        return groups
            .Where(group => group.Id == groupId)
            .SelectMany(group => group.Users)
            .Select(u => new UserView {
                Id = u.Id,
                UserName = u.UserName,
                TinyProfileImage = u.TinyProfileImage
            })
            .ToList();
    }
    
    /*[HttpGet("image/{groupId}")]
    public async Task<ActionResult<byte[]>> GetGroupImage(int groupId)
    {
        var group = await GetGroupById(groupId);
        if (group == null) return BadRequest("Group not found");

        return group.Image;
    }*/
    
    /*[HttpGet("media/{groupId}")]
    public async Task<ActionResult<IEnumerable<Media>>> GetPagesMediaByGroupId(int groupId, string? sortColumn, int pageSize = 30, int pageNumber = 1)
    {
        var group = await GetGroupById(groupId);
        if (group == null) return BadRequest("Group not found");

        IQueryable<Group> groupQuery = _context.Groups;

        /*Expression<Func<Media, object>> selector = sortColumn?.ToLower() switch
        {
            "date" => media => media.Date,
            _ => media => media.Id
        };
        
        var groupMedia = await groupQuery
            .Include(g => g.Media)
            .Where(g => g.Id == groupId)
            .SelectMany(g => g.Media)
            .Skip((pageNumber - 1) * pageSize)
            .Take(pageSize)
            //.OrderByDescending(selector)
            .ToListAsync();

        var pageCount = Math.Ceiling((double)groupMedia.Count / pageSize);
        var resultResponse = new MediaResponse()
        {
            PageNumber = pageNumber,
            PageSize = pageSize,
            PageCount = (int)pageCount,
            Media = groupMedia
        };
        
        return Ok(resultResponse);
    }*/

    [HttpGet("media")]
    public async Task<ActionResult<IEnumerable<MediaView>>> GetMediaByGroupId(int groupId)
    {
        var group = await GetGroupById(groupId);
        if (group == null) return BadRequest("Group not found");
        
        var groupMedia = await _context.Groups
            .Include(g => g.Media)
            .Where(g => g.Id == groupId)
            .SelectMany(g => g.Media)
            .Select(m => new MediaView {
                Id = m.Id,
                TinyObject = m.TinyObject
            })
            .ToListAsync();

        return groupMedia;
    }
    
    [HttpPost("create")]
    public async Task<ActionResult> CreateGroup(CreateGroupRequest request)
    {
        var owner = _usersController.GetUserById(request.OwnerId).Result;
        if (owner == null) return BadRequest("User not found");
        
        //if (_context.Groups.Any(group => group.OwnerId == request.OwnerId && group.Name == request.GroupName))
          //  return BadRequest($"Group '{request.GroupName}', created by User {request.OwnerId} already exists");

        var group = new Group
        {
            OwnerId = request.OwnerId,
            Name = request.GroupName,
            Image = Array.Empty<byte>()
        };
        
        group.Users.Add(owner);
        owner.Groups.Add(group);
        _context.Groups.Add(group);

        await _context.SaveChangesAsync();

        return Ok(group.Id);
    }

    [HttpPost("add/{groupId}/{userId}")]
    public async Task<ActionResult> AddUserToGroup(int groupId, int userId)
    {
        var group = await GetGroupById(groupId);
        if (group == null) return BadRequest("Group not found");

        var user = await _usersController.GetUserById(userId);
        if (user == null) return BadRequest("User not found");
        
        var groups = GetGroupsByUser(userId).Result.Value;
        //if (groups == null) return BadRequest("Error occured");
        
        if (groups.ToList().Contains(group)) 
            return BadRequest($"Group {groupId} already contains User {userId}");

        group.Users.Add(user);
        user.Groups.Add(group);
        await _context.SaveChangesAsync();

        return Ok($"User {userId} was successfully added to group {groupId} {group.Users.Count}");
    }

    [HttpDelete("delete/{groupId}/{userId}")]
    public async Task<ActionResult> DeleteUserFromGroup(int groupId, int userId)
    {
        var group = await GetGroupById(groupId);
        if (group == null) return BadRequest("Group not found");

        var user = await _usersController.GetUserById(userId);
        if (user == null) return BadRequest("User not found");
        
        var users = GetUsersByGroup(groupId).Result.Value;
        
        group.Users.Remove(user);
        user.Groups.Remove(group);
        
        await _context.SaveChangesAsync();
        
       /* var newUsers = users.ToList();
        newUsers.Remove(await _context.UserViews.FirstOrDefaultAsync(uv => uv.Id == user.Id));
        group.Users = newUsers;
        _context.Groups.Update(group);

        var groups = GetGroupsByUser(userId).Result.Value;
        //if (groups == null) return BadRequest("No groups found");
        
        var newGroups = groups.ToList();
        newGroups.Remove(group);
        user.Groups = newGroups;
        _context.Users.Update(user);
        
        await _context.SaveChangesAsync();*/

        return Ok($"User {userId} was successfully removed from group {groupId}");
    }

    [HttpDelete("delete/{groupId}")]
    public async Task<ActionResult> DeleteGroup(int groupId)
    {
        var group = await GetGroupById(groupId);
        if (group == null) return BadRequest($"Group not found");

        _context.Groups.Remove(group);
        await _context.SaveChangesAsync();

        return Ok("Group was deleted successfully");
    }
    
    public Task<Group?> GetGroupById(int groupId)
    {
        var group = _context.Groups.Include(group => group.Media).FirstOrDefaultAsync(g => g.Id == groupId);
        return group;
    }

    public async Task<GroupInfoResponse?> GetGroupInfo(Group group, int groupId, int userId, int dataSize)
    {
        var owner = await _usersController.GetUserById(group.OwnerId);
        if (owner == null) return null;
        
        var groupMembers = await GetUsersByGroup(groupId);
        var firstMembers = groupMembers.Value?
            .Select(u => new UserView {
                Id = u.Id,
                UserName = u.UserName,
                TinyProfileImage = u.TinyProfileImage
            })
            .Where(u => u.Id != owner.Id && u.Id != userId)
            .Take(dataSize);
        //.ToList();
        
        var groupMedia = await GetMediaByGroupId(groupId);
        var firstMedia = groupMedia.Value?
            .Select(m => new MediaView {
                Id = m.Id,
                TinyObject = m.TinyObject
            })
            .Take(dataSize);
        //.ToList(); 
        
        var resultResponse = new GroupInfoResponse()
        {
            Id = group.Id,
            DataSize = dataSize,
            Name = group.Name,
            Image = group.Image,
            Owner = new UserView {
                Id = owner.Id,
                TinyProfileImage = owner.TinyProfileImage,
                UserName = owner.UserName
            },
            FirstMedia = firstMedia,
            GallerySize = groupMedia.Value?.Count() ?? 0,
            FirstMembers = firstMembers
        };

        return resultResponse;
    }
}