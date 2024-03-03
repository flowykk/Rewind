using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MySql.Data.MySqlClient;
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
        var result = await _context.Media.FirstOrDefaultAsync(media => media.MediaId == id);
        if (result == null) return BadRequest("No media with such Id");
        
        return File(result.Photo, "application/png", "result.png");
        
        // Возврат массива байтов для медиа-файлов
        //return await _context.Media.FirstOrDefaultAsync(media => media.Id == id);
    }

    [HttpPost("load")]
    public async Task<ActionResult<Media>> LoadMedia(MediaRequest mediaRequest)
    {
        Console.WriteLine(mediaRequest.Media.Length);
        var rawData = Convert.FromBase64String(mediaRequest.Media);
        Console.WriteLine(rawData.Length);
        Console.WriteLine(rawData);
        //var rawData = System.IO.File.ReadAllBytesAsync("sample2.png").Result;
        
        var media = new Media()
        {
            Date = DateTime.Now,
            Photo = Convert.FromBase64String(mediaRequest.Media)
        };
        Console.WriteLine(media.Photo.Length);

        _context.Media.Add(media);
        await _context.SaveChangesAsync();

        return Ok(media);
    }
}