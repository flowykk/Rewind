using Microsoft.AspNetCore.Mvc;
using RewindApp.Controllers.MediaControllers;
using RewindApp.Data;
using RewindApp.Data.Repositories;
using RewindApp.Entities;
using RewindApp.Interfaces;
using RewindApp.Requests;
using RewindApp.Requests.ChangeRequests;

namespace RewindApp.Controllers.TagControllers;

[ApiController]
[Route("[controller]")]
public class TagsController : ControllerBase
{
    private readonly MediaController _mediaController;
    private readonly ITagsRepository _tagsRepository;
    
    public TagsController(DataContext context)
    {
        _mediaController = new MediaController(context);
        _tagsRepository = new TagsRepository(context);
    }
    
    [HttpGet]
    public async Task<IEnumerable<Tag>> GetTags()
    {
        return await _tagsRepository.GetTagsAsync();
    }

    [HttpGet("{mediaId}")]
    public async Task<ActionResult<IEnumerable<Tag>>> GetTagsByMediaId(int mediaId)
    {
        var media = await _mediaController.GetMediaById(mediaId);
        return Ok(_tagsRepository.GetTagsByMediaAsync(media));
    }

    [HttpPost("add/{mediaId}")]
    public async Task<ActionResult<IEnumerable<Tag>>> AddTags(TagsRequest tagsRequest, int mediaId)
    {
        var media = await _mediaController.GetMediaById(mediaId);
        if (media == null) return BadRequest("Media not found");

        foreach (var tag in tagsRequest.Tags)
        {
            await _tagsRepository.AddTagAsync(media, tag);
        }
            
        return Ok(media.Tags);
    }
    
    [HttpDelete("delete/{mediaId}")]
    public async Task<ActionResult> DeleteTag(TextRequest textRequest, int mediaId)
    {
        var media = await _mediaController.GetMediaById(mediaId);
        if (media == null) return BadRequest("Media not found");

        var tag = media.Tags.ToList().FirstOrDefault(t => t.Text == textRequest.Text);
        if (tag != null) await _tagsRepository.DeleteTagAsync(media, tag);

        return Ok(media.Tags);
    }
}