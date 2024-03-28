using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MySql.Data.MySqlClient;
using RewindApp.Controllers.GroupControllers;
using RewindApp.Controllers.UserControllers;
using RewindApp.Data;
using RewindApp.Entities;
using RewindApp.Requests;
using RewindApp.Services;

namespace RewindApp.Controllers.MediaControllers;

[ApiController]
[Route("[controller]")]
public class MediaController : ControllerBase
{
    private readonly DataContext _context;
    private readonly IGroupsController _groupsController;
    private readonly IUsersController _usersController;
    private readonly SqlService _sqlService;

    public MediaController(DataContext context) 
    {
        _context = context;
        _groupsController = new GroupsController(context);
        _usersController = new UsersController(context);
        _sqlService = new SqlService();
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
            .Include(m => m.Tags)
            .FirstOrDefaultAsync(media => media.Id == mediaId);
        return media;
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
        
        //_sqlService.Delete(userId, mediaId, "UsersId", "MediaId", "MediaUser");
        
        return Ok("unliked");
    }

    [HttpPost("load/{groupId}/{authorId}")]
    public async Task<ActionResult> LoadMediaToGroup(MediaRequest mediaRequest, int groupId, int authorId)
    {
        var group = await _groupsController.GetGroupById(groupId);
        if (group == null) return BadRequest("Group not found");
        
        var author = await _usersController.GetUserById(authorId);
        if (author == null) return BadRequest("Author not found");
        
        var rawData = Convert.FromBase64String(mediaRequest.Object);
        var tinyData = Convert.FromBase64String(mediaRequest.TinyObject);

        _sqlService.LoadMedia(rawData, tinyData, groupId, authorId, mediaRequest.isPhoto);
       
        /*var media = new Media
        {
            Date = DateTime.Now,
            Object = rawData,
            TinyObject = tinyData,
            Group = group,
            AuthorId = author.Id
        };
        
        _context.Media.Add(media);
        group.Media.Add(media);
        await _context.SaveChangesAsync();*/
;        
        return Ok("Media loaded");
    }
}