using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MySql.Data.MySqlClient;
using RewindApp.Controllers.GroupControllers;
using RewindApp.Data;
using RewindApp.Entities;
using RewindApp.Requests;

namespace RewindApp.Controllers.MediaControllers;

[ApiController]
[Route("[controller]")]
public class MediaController : ControllerBase
{
    private readonly DataContext _context;
    // private readonly ILogger<MediaController> _logger;
    private readonly IGroupsController _groupsController;

    public MediaController(DataContext context) //, ILogger<MediaController> logger, IGroupsController groupsController)
    {
        _context = context;
        _groupsController = new GroupsController(context);
    }

    [HttpGet]
    public async Task<IEnumerable<Media>> GetMedia()   
    {
        return await _context.Media.ToListAsync();
    }
    
    // may be - public async ActionResult<Media> GetMediaById(int id)
    [HttpGet("{id}")]
    public async Task<ActionResult<Media>> GetMediaById(int mediaId)
    {
        var result = await _context.Media.FirstOrDefaultAsync(media => media.Id == mediaId);
        if (result == null) return BadRequest("Media not found");
        
        return result;
        // return File(result.Photo, "application/png", "result.png");
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