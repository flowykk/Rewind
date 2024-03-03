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
//        return File(result.Photo, "application/png", "result.png");
    }

    [HttpPost("load/{groupId}")]
    public async Task<ActionResult<Media>> LoadMedia(MediaRequest mediaRequest, int groupId)
    {
        Console.WriteLine(mediaRequest.Media.Length);
        var rawData = Convert.FromBase64String(mediaRequest.Media);
        Console.WriteLine(rawData.Length);
        Console.WriteLine(rawData);
        //var rawData = System.IO.File.ReadAllBytesAsync("sample2.png").Result;

        var group = await _groupsController.GetGroupById(groupId);
        if (group == null) return BadRequest("Group not found");
        
        var media = new Media()
        {
            Date = DateTime.Now,
            Photo = Convert.FromBase64String(mediaRequest.Media),
            Group = group
        };
        Console.WriteLine(media.Photo.Length);

        _context.Media.Add(media);
        await _context.SaveChangesAsync();

        return Ok(media);
    }
}