using System.Net.Mime;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MySql.Data.MySqlClient;
using RewindApp.Controllers.UserControllers;
using RewindApp.Data;
using RewindApp.Data.Repositories.GroupRepositories;
using RewindApp.Entities;
using RewindApp.Interfaces.GroupInterfaces;
using RewindApp.Requests;
using RewindApp.Responses;
using RewindApp.Services;
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
    private readonly SqlService _sqlService;

    public GroupsController(DataContext context) 
    {
        _context = context;
        _usersController = new UsersController(context);
        _sqlService = new SqlService();
    }

    [HttpGet]
    public async Task<IEnumerable<Group>> GetGroups()
    {
        return await _context.Groups.ToListAsync();
    }
    
    [HttpGet("random/{groupId}/{userId}")]
    public async Task<ActionResult<Media>> GetRandomMediaAsync(int groupId, int userId)
    {
        if (await GetGroupById(groupId) == null)
            return BadRequest("Group not found");

        return Ok(await GetRandomBigMedia(groupId, userId));
    }
    
    [HttpGet("info/{groupId}/{userId}")]
    public async Task<ActionResult<GroupInfoResponse>> GetGroupInfoById(int groupId, int userId, int dataSize)
    {
        var group = await GetGroupById(groupId);
        if (group == null) return BadRequest("Group not found");

        var resultResponse = await GetGroupInfo(group, groupId, userId, dataSize);
        if (resultResponse == null) return BadRequest("Owner not found");
        
        return Ok(resultResponse);
    }

    [HttpGet("initial/{groupId}/{userId}")]
    public async Task<ActionResult<RewindScreenDataResponse>> GetInitialRewindScreenData(int groupId, int userId)
    {
        var groups = (await GetGroupsByUser(userId))
            .Select(g => new GroupView()
            {
                Id = g.Id,
                Name = g.Name,
                TinyImage = g.TinyImage,
                GallerySize = GetMediaByGroup(groupId).Result.ToList().Count
            });
        
        var resultResponse = new RewindScreenDataResponse {
            Groups = groups,
            RandomImage = await GetRandomBigMedia(groupId, userId),
            GallerySize = (await GetGroupById(groupId))?.Media.Count
        };

        return Ok(resultResponse);
    }

    [HttpGet("{userId}")]
    public async Task<ActionResult<List<Group>>> GetGroupsByUserAsync(int userId)
    {
        if (await _usersController.GetUserById(userId) == null)
            return BadRequest("User not found");
        
        return Ok(await GetGroupsByUser(userId));
    }
    
    [HttpGet("users")]
    public async Task<ActionResult<IEnumerable<UserView>>> GetUsersByGroup(int groupId)
    {
        if (await GetGroupById(groupId) == null)
            return BadRequest("Group not found");

        return Ok(await GetUserViewsByGroupAsync(groupId));
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

    [HttpGet("media/{groupId}")]
    public async Task<ActionResult<IEnumerable<MediaView>>> GetMediaByGroupAsync(int groupId, int mediaId = 0)
    {
        var group = await GetGroupById(groupId);
        if (group == null) return BadRequest("Group not found");
        
//      return Ok((await GetMediaByGroup(groupId)).Where(m => m.Id > mediaId));
        return Ok(await GetMediaByGroup(groupId, mediaId));
    }
    
    [HttpPost("create")]
    public async Task<ActionResult<int>> CreateGroup(CreateGroupRequest request)
    {
        var owner = _usersController.GetUserById(request.OwnerId).Result;
        if (owner == null) return BadRequest("User not found");
        
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

        return Ok(group.Id);
    }

    [HttpPost("add/{groupId}/{userId}")]
    public async Task<ActionResult<GroupInfoResponse>> AddUserToGroup(int groupId, int userId, int dataSize = 5)
    {
        var group = await GetGroupById(groupId);
        if (group == null) return BadRequest("Group not found");

        var user = await _usersController.GetUserById(userId);
        if (user == null) return BadRequest("User not found");
        
        var resultResponse = await GetGroupInfo(group, groupId, userId, dataSize);
        if (resultResponse == null) return BadRequest("Owner not found");

        if ((await GetUsersByGroupAsync(groupId)).ToList().Contains(user)) 
            return Ok(resultResponse);
        
        group.Users.Add(user);
        user.Groups.Add(group);
        await _context.SaveChangesAsync();

        return Ok(resultResponse);
    }

    [HttpDelete("delete/{groupId}/{userId}")]
    public async Task<ActionResult> DeleteUserFromGroup(int groupId, int userId)
    {
        var group = await GetGroupById(groupId);
        if (group == null) return BadRequest("Group not found");

        var user = await _usersController.GetUserById(userId);
        if (user == null) return BadRequest("User not found");
        
        _sqlService.Delete(groupId, userId, "GroupsId", "UsersId", "GroupUser");

        return Ok($"User {userId} was successfully removed from group {groupId}");
    }

    [HttpDelete("delete/{groupId}")]
    public async Task<ActionResult> DeleteGroup(int groupId)
    {
        var group = await GetGroupById(groupId);
        if (group == null) return BadRequest("Group not found");

        _context.Groups.Remove(group);
        await _context.SaveChangesAsync();

        return Ok("Group was deleted successfully");
    }
    
    public async Task<Group?> GetGroupById(int groupId)
    {
        var group = await _context.Groups.Include(group => group.Media).FirstOrDefaultAsync(g => g.Id == groupId);
        return group;
    }

    public async Task<GroupInfoResponse?> GetGroupInfo(Group group, int groupId, int userId, int dataSize)
    {
        var owner = await _usersController.GetUserById(group.OwnerId);
        if (owner == null) return null;
        
        var firstMembers = (await GetUserViewsByGroupAsync(groupId))
            .Select(u => new UserView {
                Id = u.Id,
                UserName = u.UserName,
                TinyProfileImage = u.TinyProfileImage
            })
            .Where(u => u.Id != owner.Id && u.Id != userId)
            .Take(dataSize);
        
        var firstMedia = (await GetMediaByGroup(groupId)).Take(dataSize);
        
        var resultResponse = new GroupInfoResponse {
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
            GallerySize = group.Media.Count,
            FirstMembers = firstMembers
        };

        return resultResponse;
    }

    public async Task<IEnumerable<Group>> GetGroupsByUser(int userId)
    {
        return await _context.Users
            .Include(user => user.Groups)
            .Where(user => user.Id == userId)
            .SelectMany(user => user.Groups).ToListAsync();
    }

    public async Task<IEnumerable<UserView>> GetUserViewsByGroupAsync(int groupId)
    {
        return await _context.Groups
            .Include(group => group.Users)
            .Where(group => group.Id == groupId)
            .SelectMany(group => group.Users)
            .Select(u => new UserView {
                Id = u.Id,
                UserName = u.UserName,
                TinyProfileImage = u.TinyProfileImage
            })
            .ToListAsync();
    }
    
    public async Task<IEnumerable<User>> GetUsersByGroupAsync(int groupId)
    {
        return await _context.Groups
            .Include(group => group.Users)
            .Where(group => group.Id == groupId)
            .SelectMany(group => group.Users)
            .ToListAsync();
    }
    
    public async Task<IEnumerable<MediaView>> GetMediaByGroup(int groupId, int mediaId = 0)
    {
        return await _context.Groups
            .Include(g => g.Media)
            .Where(g => g.Id == groupId)
            .SelectMany(g => g.Media)
            .Select(m => new MediaView {
                Id = m.Id,
                TinyObject = m.TinyObject
            })
            .Where(m => m.Id > mediaId)
            .ToListAsync();
    }
    
    public async Task<IEnumerable<BigMediaView>> GetBigMediaByGroup(int groupId, int userId)
    {
        var user = await _usersController.GetUserById(userId);
        return await _context.Groups
            .Include(g => g.Media)
            .Where(g => g.Id == groupId)
            .SelectMany(g => g.Media)
            .Where(m => m.Author != null)
            .Select(m => new BigMediaView {
                Id = m.Id,
                Object = m.Object,
                Author = new UserView {
                    Id = m.Author.Id,
                    TinyProfileImage = m.Author.TinyProfileImage,
                    UserName = m.Author.UserName
                },
                Date = m.Date,
                Liked = _usersController.GetLikedMediaByUser(userId).Result.Contains(m)
            })
            .ToListAsync();
    }

    public async Task<MediaView?> GetRandomMedia(int groupId)
    {
        var media = (await GetMediaByGroup(groupId)).ToList();
        return media.Count == 0 ? null : media[new Random().Next(0, media.Count)];
    }
    
    public async Task<BigMediaView?> GetRandomBigMedia(int groupId, int userId)
    {
        var media = (await GetBigMediaByGroup(groupId, userId)).ToList();
        return media.Count == 0 ? null : media[new Random().Next(0, media.Count)];
    }
}