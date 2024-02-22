using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RewindApp.Data;
using RewindApp.Models;

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
    
    [HttpGet("{id}")]
    public async Task<ActionResult<Media>> GetMediaById(int id)
    {
        // Возврат медиа-файла 
        return File(_context.Media.FirstOrDefaultAsync(media => media.Id == id).Result.Photo, "application/png", "result.png");
        
        // Возврат массива байтов для медиа-файлов
        //return await _context.Media.FirstOrDefaultAsync(media => media.Id == id);
    }

    [HttpPost("load")]
    public async Task<ActionResult<IEnumerable<Media>>> LoadMedia(byte[] mediaBytes)
    {
        Console.WriteLine(mediaBytes);
        var media = new Media()
        {
            Date = DateTime.Now,
            Photo = mediaBytes
        };
        
        _context.Media.Add(media);
        await _context.SaveChangesAsync();

        return Ok("User created successfully!");
    }

    // [HttpPost("loadMedia")]
    // {
    //     
    // }
}