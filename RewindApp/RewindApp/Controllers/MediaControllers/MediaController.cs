using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MySql.Data.MySqlClient;
using RewindApp.Controllers.GroupControllers;
using RewindApp.Controllers.UserControllers;
using RewindApp.Data;
using RewindApp.Entities;
using RewindApp.Requests;

namespace RewindApp.Controllers.MediaControllers;

[ApiController]
[Route("[controller]")]
public class MediaController : ControllerBase
{
    private readonly DataContext _context;
    private readonly IGroupsController _groupsController;
    private readonly IUsersController _usersController;

    public MediaController(DataContext context) 
    {
        _context = context;
        _groupsController = new GroupsController(context);
        _usersController = new UsersController(context);
    }

    [HttpGet]
    public async Task<IEnumerable<Media>> GetMedia()   
    {
        return await _context.Media.ToListAsync();
    }
    
    [HttpGet("{mediaId}")]
    public async Task<ActionResult<Media>> GetMediaById(int mediaId)
    {
        var result = await _context.Media.FirstOrDefaultAsync(media => media.Id == mediaId);
        if (result == null) return BadRequest("Media not found");
        
        return result;
    }

    [HttpPost("like/{userId}/{mediaId}")]
    public async Task<ActionResult<Media>> LikeMedia(int userId, int mediaId)
    {
        var user = await _usersController.GetUserById(userId);
        if (user == null) return BadRequest("User not found");
        
        var media = await GetMediaById(mediaId);
        if (media.Value == null) return BadRequest("Media not found");

        user.Media.Add(media.Value);
        media.Value.Users.Add(user);
        await _context.SaveChangesAsync();
        
        return Ok("ok");
    }
    
    [HttpDelete("unlike/{userId}/{mediaId}")]
    public async Task<ActionResult<Media>> UnlikeMedia(int userId, int mediaId)
    {
        var user = await _usersController.GetUserById(userId);
        if (user == null) return BadRequest("User not found");
        
        var media = GetMediaById(mediaId).Result.Value;
        if (media == null) return BadRequest("Media not found");
        
        var users = media.Users;
        
        var newUsers = users.ToList();
        newUsers.Remove(user);
        media.Users = newUsers;
        _context.Media.Update(media);

        var medias = user.Media;
        
        var newMedia = medias.ToList();
        newMedia.Remove(media);
        user.Media = newMedia;
        _context.Users.Update(user);
        
        await _context.SaveChangesAsync();
        
        return Ok("ok");
    }

    [HttpPost("load/{groupId}")]
    public async Task<ActionResult> LoadMediaToGroup(MediaRequest mediaRequest, int groupId)
    {
        var group = await _groupsController.GetGroupById(groupId);
        if (group == null) return BadRequest("Group not found");
        
        var rawData = Convert.FromBase64String(mediaRequest.Object);
        var tinyData = Convert.FromBase64String(mediaRequest.TinyObject);
        var date = DateTime.Now;

        var connectionString = DataContext.GetDbConnection();
        var connection = new MySqlConnection(connectionString);
        connection.Open();

        var command = new MySqlCommand()
        {
            Connection = connection,
            CommandText = "INSERT INTO Media (Date, Object, TinyObject, GroupId) VALUES (?date, ?rawData, ?tinyData, ?groupId);"
        };
        var imageParameter = new MySqlParameter("?rawData", MySqlDbType.Blob, rawData.Length)
        {
            Value = rawData
        };
        var tinyImageParameter = new MySqlParameter("?tinyData", MySqlDbType.TinyBlob, tinyData.Length)
        {
            Value = tinyData
        };
        var dateParameter = new MySqlParameter("?date", MySqlDbType.DateTime)
        {
            Value = date
        };
        var groupIdParameter = new MySqlParameter("?groupId", MySqlDbType.Int64)
        {
            Value = groupId
        };

        var media = new Media()
        {
            Date = date,
            Object = rawData
        };
        
        _context.Media.Add(media);
        group.Media.Add(media);
        await _context.SaveChangesAsync();
        
        command.Parameters.Add(imageParameter);
        command.Parameters.Add(tinyImageParameter);
        command.Parameters.Add(dateParameter);
        command.Parameters.Add(groupIdParameter);
        command.ExecuteNonQuery();
        
        return Ok("Media loaded");
    }
}