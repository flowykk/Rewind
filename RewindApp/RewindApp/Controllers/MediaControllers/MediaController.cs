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
    public async Task<Media?> GetMediaById(int mediaId)
    {
        var result = await _context.Media.FirstOrDefaultAsync(media => media.Id == mediaId);
        return result;
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

    [HttpPost("load/{groupId}/{authorId}")]
    public async Task<ActionResult> LoadMediaToGroup(MediaRequest mediaRequest, int groupId, int authorId)
    {
        var group = await _groupsController.GetGroupById(groupId);
        if (group == null) return BadRequest("Group not found");
        
        var author = await _usersController.GetUserById(authorId);
        if (author == null) return BadRequest("Author not found");
        
        var rawData = Convert.FromBase64String(mediaRequest.Object);
        var tinyData = Convert.FromBase64String(mediaRequest.TinyObject);
        var date = DateTime.Now;

        var connectionString = DataContext.GetDbConnection();
        var connection = new MySqlConnection(connectionString);
        connection.Open();

        var command = new MySqlCommand()
        {
            Connection = connection,
            CommandText = "INSERT INTO Media (Date, Object, TinyObject, GroupId, AuthorId) VALUES (?date, ?rawData, ?tinyData, ?groupId, ?authorId);"
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
        var authorIdParameter = new MySqlParameter("?authorId", MySqlDbType.Int64)
        {
            Value = authorId
        };
        
        var media = new Media
        {
            Date = date,
            Object = rawData,
            TinyObject = tinyData,
            Group = group,
            AuthorId = author.Id
        };
        
        _context.Media.Add(media);
        group.Media.Add(media);
        await _context.SaveChangesAsync();
        
        command.Parameters.Add(imageParameter);
        command.Parameters.Add(tinyImageParameter);
        command.Parameters.Add(dateParameter);
        command.Parameters.Add(groupIdParameter);
        command.Parameters.Add(authorIdParameter);
        command.ExecuteNonQuery();
;        
        return Ok("Media loaded");
    }
}