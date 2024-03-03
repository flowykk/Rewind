using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RewindApp.Data;
using RewindApp.Requests.ChangeRequests;
using RewindApp.Requests;
using RewindApp.Services;
using MySql.Data.MySqlClient;
using RewindApp.Entities;

namespace RewindApp.Controllers.TagControllers;

[ApiController]
[Route("[controller]")]
public class TagsController : ControllerBase
{
    private readonly DataContext _context;
    private readonly ILogger<TagsController> _logger;

    public TagsController(DataContext context, ILogger<TagsController> logger)
    {
        _context = context;
        _logger = logger;
    }
    
    [HttpGet]
    public async Task<ActionResult<IEnumerable<Tag>>> GetTags()
    {
        return await _context.Tags.ToListAsync();
    }

    [HttpGet("{mediaId}")]
    public async Task<ActionResult<IEnumerable<Tag>>> GetTagsByMediaId(int mediaId)
    {
        var media = await _context.Media.Include(m => m.Tags).FirstOrDefaultAsync(m => m.Id == mediaId);
        if (media == null) return BadRequest("Media not found");

        return media.Tags.ToList();
    }

    [HttpPost("add/{mediaId}")]
    public async Task<ActionResult> AddTag(NameRequest nameRequest, int mediaId)
    {
        var media = await _context.Media.FirstOrDefaultAsync(m => m.Id == mediaId);
        if (media == null) return BadRequest("Media not found");

        var tag = new Tag()
        {
            Text = nameRequest.Name,
            Media = media
        };

        _context.Tags.Add(tag);
        await _context.SaveChangesAsync();

        return Ok(tag);
    }
}