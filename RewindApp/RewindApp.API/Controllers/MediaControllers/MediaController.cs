using Microsoft.AspNetCore.Mvc;
using RewindApp.Application.Interfaces.GroupInterfaces;
using RewindApp.Application.Interfaces.MediaInterfaces;
using RewindApp.Application.Interfaces.UserInterfaces;
using RewindApp.Infrastructure.Data;
using RewindApp.Domain.Entities;
using RewindApp.Domain.Requests.MediaRequests;
using RewindApp.Domain.Views.MediaViews;
using RewindApp.Infrastructure.Data.Repositories.GroupRepositories;
using RewindApp.Infrastructure.Data.Repositories.MediaRepositories;
using RewindApp.Infrastructure.Data.Repositories.UserRepositories;

namespace RewindApp.Controllers.MediaControllers;

[ApiController]
[Route("[controller]")]
public class MediaController : ControllerBase
{
    private readonly IGroupRepository _groupRepository;
    private readonly IUserRepository _userRepository;
    private readonly IMediaRepository _mediaRepository;

    public MediaController(DataContext context) 
    {
        _groupRepository = new GroupRepository(context);
        _userRepository = new UserRepository(context);
        _mediaRepository = new MediaRepository(context);
    }

    [HttpGet]
    public async Task<IEnumerable<Media>> GetMedia()
    {
        return await _mediaRepository.GetMediaAsync();
    }
    
    [HttpGet("{mediaId}")]
    public async Task<Media?> GetMediaById(int mediaId)
    {
        return await _mediaRepository.GetMediaByIdAsync(mediaId);
    }
    
    [HttpGet("info/{mediaId}/{userId}")]
    public async Task<ActionResult<LargeMediaInfoResponse>> GetMediaInfoById(int mediaId, int userId)
    {
        var media = await GetMediaById(mediaId);
        if (media == null) return BadRequest("Media not found");

        return Ok(await _mediaRepository.GetMediaInfoByIdAsync(media, userId));
    }
    
    [HttpPost("like/{userId}/{mediaId}")]
    public async Task<ActionResult> LikeMedia(int userId, int mediaId)
    {
        var user = await _userRepository.GetUserByIdAsync(userId);
        if (user == null) return BadRequest("User not found");
        
        var media = await GetMediaById(mediaId);
        if (media == null) return BadRequest("Media not found");

        await _mediaRepository.LikeMediaAsync(media, user);
        
        return Ok("liked");
    }

    [HttpDelete("unlike/{userId}/{mediaId}")]
    public async Task<ActionResult> UnlikeMedia(int userId, int mediaId)
    {
        var user = await _userRepository.GetUserByIdAsync(userId);
        if (user == null) return BadRequest("User not found");
        
        var media = await GetMediaById(mediaId);
        if (media == null) return BadRequest("Media not found");

        await _mediaRepository.UnlikeMediaAsync(media, user);
        
        return Ok("unliked");
    }

    [HttpPost("load/{groupId}/{authorId}")]
    public async Task<ActionResult> LoadMediaToGroup(LoadMediaRequest mediaRequest, int groupId, int authorId)
    {
        var group = await _groupRepository.GetGroupByIdAsync(groupId);
        if (group == null) return BadRequest("Group not found");
        
        var author = await _userRepository.GetUserByIdAsync(authorId);
        if (author == null) return BadRequest("Author not found");
        
        var id = await _mediaRepository.LoadMediaToGroupAsync(mediaRequest, groupId, authorId);
        
        return Ok(id);
    }
    
    [HttpDelete("unload/{mediaId}/{groupId}")]
    public async Task<ActionResult> UnloadMediaFromGroup(int mediaId, int groupId)
    {
        var group = await _groupRepository.GetGroupByIdAsync(groupId);
        if (group == null) return BadRequest("Group not found");

        var media = await GetMediaById(mediaId);
        if (media == null) return BadRequest("Media not found");
        
        await _mediaRepository.UnloadMediaFromGroupAsync(media, group);
        
        return Ok(media.Id);
    }
}