using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MySql.Data.MySqlClient;
using RewindApp.Data;
using RewindApp.Entities;
using RewindApp.Requests.ChangeRequests;

namespace RewindApp.Controllers;

[ApiController]
[Route("[controller]")]
public class MediaController : ControllerBase
{
    private readonly DataContext _context;
    private readonly ILogger<MediaController> _logger;

    public MediaController(DataContext context, ILogger<MediaController> logger)
    {
        _context = context;
        _logger = logger;
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
        // Возврат медиа-файла
        var result = _context.Media.FirstOrDefaultAsync(media => media.Id == id).Result;
        if (result == null) return BadRequest("No media with such Id");
        
        return File(result.Photo, "application/png", "result.png");
        
        // Возврат массива байтов для медиа-файлов
        //return await _context.Media.FirstOrDefaultAsync(media => media.Id == id);
    }

    [HttpPost("load")]
    public async Task<ActionResult> LoadMedia(MediaRequest mediaRequest)
    {
        var rawData = mediaRequest.Media;
        //var rawData = await System.IO.File.ReadAllBytesAsync("sample2.png");
        var date = DateTime.Now;
        
        var server = "localhost";
        var databaseName = "rewinddb";
        var userName = "rewinduser";
        var password = "rewindpass";

        var connectionString = $"Server={server}; Port=3306; Database={databaseName}; UID={userName}; Pwd={password}";
        //                       Server=myServerAddress; Port=1234; Database=myDataBase; Uid=myUsername; Pwd=myPassword;
        var connection = new MySqlConnection(connectionString);
        connection.Open();
        
        var command = new MySqlCommand()
        {
            Connection = connection,
            CommandText = "INSERT INTO Media (Date, Photo) VALUES (?date, ?rawData);"
        };
        var fileContentParameter = new MySqlParameter("?rawData", MySqlDbType.Blob, rawData.Length)
        {
            Value = rawData
        };
        var dateParameter = new MySqlParameter("?date", MySqlDbType.DateTime)
        {
            Value = date
        };
        command.Parameters.Add(fileContentParameter);
        command.Parameters.Add(dateParameter);

        command.ExecuteNonQuery();
        
        /*var rawData = System.IO.File.ReadAllBytesAsync("sample2.png").Result;
        Console.WriteLine(rawData.Length);
        
        var media = new Media()
        {
            Date = DateTime.Now,
            Photo = rawData
        };

        _context.Media.Add(media);
        await _context.SaveChangesAsync();*/

        return Ok("loaded");
    }
}