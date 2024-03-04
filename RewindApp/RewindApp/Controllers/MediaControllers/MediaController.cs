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
    private readonly ILogger<MediaController> _logger;
    private readonly IGroupsController _groupsController;

    public MediaController(DataContext context, ILogger<MediaController> logger, IGroupsController groupsController)
    {
        _context = context;
        _logger = logger;
        _groupsController = groupsController;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<Media>>> GetMedia()   
    {
        return await _context.Media.ToListAsync();
    }
    
    // may be - public async ActionResult<Media> GetMediaById(int id)
    [HttpGet("{id}")]
    public async Task<ActionResult<Media>> GetMediaById(int id)
    {
        var result = await _context.Media.FirstOrDefaultAsync(media => media.Id == id);
        if (result == null) return BadRequest("No media with such Id");
        
        return result;
        // return File(result.Photo, "application/png", "result.png");
    }

    [HttpPost("load/{groupId}")]
    public async Task<ActionResult<Media>> LoadMedia(MediaRequest mediaRequest, int groupId)
    {
        var group = await _groupsController.GetGroupById(groupId);
        if (group == null) return BadRequest("Group not found");
        
        var rawData = Convert.FromBase64String(mediaRequest.Media);
        var date = DateTime.Now;

        var connectionString = DataContext.GetDbConnection();
        var connection = new MySqlConnection(connectionString);
        connection.Open();

        var command = new MySqlCommand()
        {
            Connection = connection,
            CommandText = "INSERT INTO Media (Date, Photo, GroupId) VALUES (?date, ?rawData, ?groupId);"
        };
        var fileContentParameter = new MySqlParameter("?rawData", MySqlDbType.Blob, rawData.Length)
        {
            Value = rawData
        };
        var dateParameter = new MySqlParameter("?date", MySqlDbType.DateTime)
        {
            Value = date
        };
        var groupIdParameter = new MySqlParameter("?groupId", MySqlDbType.Int64)
        {
            Value = groupId
        };
        command.Parameters.Add(fileContentParameter);
        command.Parameters.Add(dateParameter);
        command.Parameters.Add(groupIdParameter);

        command.ExecuteNonQuery();

        return Ok("Media added");
    }
}