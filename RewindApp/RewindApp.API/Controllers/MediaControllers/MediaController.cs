using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RewindApp.Application.Interfaces;
using RewindApp.Controllers.GroupControllers;
using RewindApp.Controllers.UserControllers;
using RewindApp.Infrastructure.Data;
using RewindApp.Infrastructure.Data.Repositories;
using RewindApp.Domain.Entities;
using RewindApp.Domain.Requests.MediaRequests;
using RewindApp.Infrastructure.Services;
using RewindApp.Domain.Views.MediaViews;

namespace RewindApp.Controllers.MediaControllers;

[ApiController]
[Route("[controller]")]
public class MediaController : ControllerBase
{
    private readonly DataContext _context;
    private readonly IGroupsController _groupsController;
    private readonly IUsersController _usersController;
    private readonly SqlService _sqlService;

    private readonly ITagsRepository _tagsRepository;

    public MediaController(DataContext context) 
    {
        _context = context;
        _groupsController = new GroupsController(context);
        _usersController = new UsersController(context);
        _sqlService = new SqlService();
        _tagsRepository = new TagsRepository(context);
    }

    [HttpGet]
    public async Task<IEnumerable<Media>> GetMedia()   
    {
        return await _context.Media.ToListAsync();
    }
    
    [HttpGet("{mediaId}")]
    public async Task<Media?> GetMediaById(int mediaId)
    {
        var media = await _context.Media
            .Include(m => m.Users)
            .Include(m => m.Author)
            .Include(m => m.Tags)
            .FirstOrDefaultAsync(media => media.Id == mediaId);
        return media;
    }
    
    [HttpGet("info/{mediaId}/{userId}")]
    public async Task<ActionResult<LargeMediaInfoResponse>> GetMediaInfoById(int mediaId, int userId)
    {
        var media = await GetMediaById(mediaId);
        if (media == null) return BadRequest("Media not found");

        return Ok(new LargeMediaInfoResponse {
            Id = mediaId,
            Author = media.Author,
            Date = media.Date,
            Object = media.Object,
            Liked = (await _usersController.GetLikedMediaByUser(userId)).Contains(media),
            Tags = media.Tags
        });
    }
    
    [HttpPost("like/{userId}/{mediaId}")]
    public async Task<ActionResult<Media>> LikeMedia(int userId, int mediaId)
    {
        var user = await _usersController.GetUserById(userId);
        if (user == null) return BadRequest("User not found");
        
        var media = await GetMediaById(mediaId);
        if (media == null) return BadRequest("Media not found");

        user.Media.Add(media);
        media.Users.Add(user);
        await _context.SaveChangesAsync();
        
        return Ok("liked");
    }

    [HttpDelete("unlike/{userId}/{mediaId}")]
    public async Task<ActionResult<Media>> UnlikeMedia(int userId, int mediaId)
    {
        var user = await _usersController.GetUserById(userId);
        if (user == null) return BadRequest("User not found");
        
        var media = await GetMediaById(mediaId);
        if (media == null) return BadRequest("Media not found");

        user.Media.Remove(media);
        media.Users.Remove(user);
        await _context.SaveChangesAsync();
        
        return Ok("unliked");
    }

    [HttpPost("load/{groupId}/{authorId}")]
    public async Task<ActionResult> LoadMediaToGroup(LoadMediaRequest mediaRequest, int groupId, int authorId)
    {
        var group = await _groupsController.GetGroupById(groupId);
        if (group == null) return BadRequest("Group not found");
        
        var author = await _usersController.GetUserById(authorId);
        if (author == null) return BadRequest("Author not found");
        
        var rawData = Convert.FromBase64String(mediaRequest.Object);
        var tinyData = Convert.FromBase64String(mediaRequest.TinyObject);

        var id = _sqlService.LoadMedia(rawData, tinyData, groupId, authorId, mediaRequest.IsPhoto);
        
        foreach (var tag in mediaRequest.Tags)
            await _tagsRepository.AddTagAsync((await GetMediaById(id))!, tag);
        
        return Ok(id);
    }
    
    [HttpDelete("unload/{mediaId}/{groupId}")]
    public async Task<ActionResult> UnloadMediaFromGroup(int mediaId, int groupId)
    {
        var group = await _groupsController.GetGroupById(groupId);
        if (group == null) return BadRequest("Group not found");

        var media = await GetMediaById(mediaId);
        if (media == null) return BadRequest("Media not found");

        var author = media.Author == null ? null : await _usersController.GetUserById(media.Author.Id);

        group.Media.Remove(media);
        author?.Media.Remove(media);
        await _context.SaveChangesAsync();
        
        return Ok(media.Id);
    }
}