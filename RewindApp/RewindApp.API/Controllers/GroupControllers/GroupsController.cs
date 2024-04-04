using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RewindApp.Controllers.UserControllers;
using RewindApp.Infrastructure.Data;
using RewindApp.Domain.Entities;
using RewindApp.Application.Extensions;
using RewindApp.Domain.Requests;
using RewindApp.Domain.Responses;
using RewindApp.Domain.Views;
using RewindApp.Domain.Views.GroupViews;
using RewindApp.Domain.Views.MediaViews;

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

    public GroupsController(DataContext context) 
    {
        _context = context;
        _usersController = new UsersController(context);
    }

    [HttpGet]
    public async Task<IEnumerable<Group>> GetGroups()
    {
        return await _context.Groups.ToListAsync();
    }
    
    [HttpGet("random/{groupId}/{userId}")]
    public async Task<ActionResult<BigMediaInfoResponse>> GetRandomMedia(int groupId, int userId, bool images = true, bool quotes = true, bool onlyFavorites = false)
    {
        if (await GetGroupById(groupId) == null)
            return BadRequest("Group not found");

        var filter = new FilterSettings {
            Images = images,
            Quotes = quotes,
            OnlyFavorites = onlyFavorites
        };
        
        return Ok(await GetRandomBigMediaAsync(filter, groupId, userId));
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
        var group = await GetGroupById(groupId);
        
        var groups = (await GetGroupsByUserAsync(userId))
            .Select(g => new GroupView()
            {
                Id = g.Id,
                Name = g.Name,
                OwnerId = g.OwnerId,
                TinyImage = g.TinyImage,
                GallerySize = GetMediaByGroupAsync(g.Id).Result.Count()
            });
        
        var resultResponse = new RewindScreenDataResponse {
            Groups = groups,
            RandomImage = await GetRandomBigMediaAsync(new FilterSettings(), groupId, userId),
            GallerySize = group != null ? group.Media.Count : 0
        };

        return Ok(resultResponse);
    }

    [HttpGet("{userId}")]
    public async Task<ActionResult<IEnumerable<GroupView>>> GetGroupsByUser(int userId)
    {
        if (await _usersController.GetUserById(userId) == null)
            return BadRequest("User not found");
        
        return Ok((await GetGroupsByUserAsync(userId))
            .Select(g => new GroupView()
            {
                Id = g.Id,
                Name = g.Name,
                OwnerId = g.OwnerId,
                TinyImage = g.TinyImage,
                GallerySize = GetMediaByGroupAsync(g.Id).Result.Count()
            }));
    }
    
    [HttpGet("users")]
    public async Task<ActionResult<IEnumerable<UserView>>> GetUsersByGroup(int groupId)
    {
        if (await GetGroupById(groupId) == null)
            return BadRequest("Group not found");

        return Ok(await GetUserViewsByGroupAsync(groupId));
    }

    [HttpGet("media/{groupId}")]
    public async Task<ActionResult<IEnumerable<MediaView>>> GetMediaByGroup(int groupId, int mediaId = 0)
    {
        var group = await GetGroupById(groupId);
        if (group == null) return BadRequest("Group not found");
        
        return Ok((await GetMediaByGroupAsync(groupId)).Where(m => m.Id > mediaId));
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
    public async Task<ActionResult<SmallGroupInfoResponse>> AddUserToGroup(int groupId, int userId)
    {
        var group = await GetGroupById(groupId);
        if (group == null) return BadRequest("Group not found");

        var user = await _usersController.GetUserById(userId);
        if (user == null) return BadRequest("User not found");
        
        var resultResponse = GetSmallGroupInfo(group);
        //if (resultResponse == null) return BadRequest("Owner not found");

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

        user.Groups.Remove(group);
        group.Users.Remove(user);
        await _context.SaveChangesAsync();
        
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
        var group = await _context.Groups
            .Include(group => group.Media)
            .Include(group => group.Users)
            .FirstOrDefaultAsync(g => g.Id == groupId);
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
            .Shuffle()
            .Take(dataSize);
        
        var firstMedia = (await GetMediaByGroupAsync(groupId))
            .Shuffle()
            .Take(dataSize);
        
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
    
    public SmallGroupInfoResponse GetSmallGroupInfo(Group group)
    {
        // var owner = await _usersController.GetUserById(group.OwnerId);
        // if (owner == null) return null;
        
        var resultResponse = new SmallGroupInfoResponse {
            Id = group.Id,
            Name = group.Name,
            OwnerId = group.OwnerId,
            TinyImage = group.TinyImage
        };

        return resultResponse;
    }

    public async Task<IEnumerable<Group>> GetGroupsByUserAsync(int userId)
    {
        return await _context.Users
            .Include(user => user.Groups)
            .Where(user => user.Id == userId)
            .SelectMany(user => user.Groups)
            .ToListAsync();
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
    
    public async Task<IEnumerable<MediaView>> GetMediaByGroupAsync(int groupId, int mediaId = 0)
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
    
    public async Task<IEnumerable<BigMediaInfoResponse>> GetBigMediaByGroupAsync(FilterSettings filterSettings, int groupId, int userId)
    {
        return await _context.Groups
            .Include(g => g.Media)
            .Where(g => g.Id == groupId)
            .SelectMany(g => g.Media)
            .Where(m => m.Author != null && ((m.IsPhoto && filterSettings.Images) || (!m.IsPhoto && filterSettings.Quotes)))
            .Where(m => !filterSettings.OnlyFavorites || 
                filterSettings.OnlyFavorites && _usersController.GetLikedMediaByUser(userId).Result.Contains(m))
            .Select(m => new BigMediaInfoResponse {
                Id = m.Id,
                Object = m.Object,
                Author = new UserView {
                    Id = m.Author!.Id,
                    TinyProfileImage = m.Author.TinyProfileImage,
                    UserName = m.Author.UserName
                },
                Date = m.Date,
                Liked = _usersController.GetLikedMediaByUser(userId).Result.Contains(m)
            })
            .ToListAsync();
    }

    public async Task<MediaView?> GetRandomMediaAsync(int groupId)
    {
        var media = (await GetMediaByGroupAsync(groupId)).ToList();
        return media.Count == 0 ? null : media[new Random().Next(0, media.Count)];
    }
    
    public async Task<BigMediaInfoResponse?> GetRandomBigMediaAsync(FilterSettings filterSettings, int groupId, int userId)
    {
        var media = (await GetBigMediaByGroupAsync(filterSettings, groupId, userId)).ToList();
        return media.Count == 0 ? null : media[new Random().Next(0, media.Count)];
    }
}