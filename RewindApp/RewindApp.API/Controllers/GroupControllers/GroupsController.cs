using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RewindApp.Controllers.UserControllers;
using RewindApp.Infrastructure.Data;
using RewindApp.Domain.Entities;
using RewindApp.Application.Extensions;
using RewindApp.Application.Interfaces.GroupInterfaces;
using RewindApp.Application.Interfaces.UserInterfaces;
using RewindApp.Domain.Requests;
using RewindApp.Domain.Responses;
using RewindApp.Domain.Views;
using RewindApp.Domain.Views.GroupViews;
using RewindApp.Domain.Views.MediaViews;
using RewindApp.Infrastructure.Data.Repositories.GroupRepositories;
using RewindApp.Infrastructure.Data.Repositories.UserRepositories;

namespace RewindApp.Controllers.GroupControllers;

[ApiController]
[Route("[controller]")]
public class GroupsController : ControllerBase
{
    private readonly IUserRepository _userRepository;
    private readonly IGroupRepository _groupRepository;

    public GroupsController(DataContext context) 
    {
        _userRepository = new UserRepository(context);
        _groupRepository = new GroupRepository(context);
    }

    [HttpGet]
    public async Task<IEnumerable<Group>> GetGroups()
    {
        return await _groupRepository.GetGroupsAsync();
    }
    
    [HttpGet("random/{groupId}/{userId}")]
    public async Task<ActionResult<BigMediaInfoResponse>> GetRandomMedia(int groupId, int userId, bool images = true, bool quotes = true, bool onlyFavorites = false)
    {
        if (await _groupRepository.GetGroupByIdAsync(groupId) == null)
            return BadRequest("Group not found");

        return Ok(await _groupRepository.GetRandomMediaAsync(groupId, userId, images, quotes, onlyFavorites));
    }
    
    [HttpGet("info/{groupId}/{userId}")]
    public async Task<ActionResult<GroupInfoResponse>> GetGroupInfoById(int groupId, int userId, int dataSize)
    {
        var group = await _groupRepository.GetGroupByIdAsync(groupId);
        if (group == null) return BadRequest("Group not found");

        var resultResponse = await _groupRepository.GetGroupInfoAsync(group, userId, dataSize);
        if (resultResponse == null) return BadRequest("Owner not found");
        
        return Ok(resultResponse);
    }

    [HttpGet("initial/{groupId}/{userId}")]
    public async Task<ActionResult<RewindScreenDataResponse>> GetInitialRewindScreenData(int groupId, int userId)
    {
        return Ok(await _groupRepository.GetInitialRewindScreenDataAsync(groupId, userId));
    }

    [HttpGet("{userId}")]
    public async Task<ActionResult<IEnumerable<GroupView>>> GetGroupsByUser(int userId)
    {
        if (await _userRepository.GetUserByIdAsync(userId) == null)
            return BadRequest("User not found");
        
        return Ok(await _groupRepository.GetGroupViewsByUserAsync(userId));
    }
    
    [HttpGet("users")]
    public async Task<ActionResult<IEnumerable<UserView>>> GetUsersByGroup(int groupId)
    {
        if (await _groupRepository.GetGroupByIdAsync(groupId) == null)
            return BadRequest("Group not found");

        return Ok(await _groupRepository.GetUserViewsByGroupAsync(groupId));
    }

    [HttpGet("media/{groupId}")]
    public async Task<ActionResult<IEnumerable<MediaView>>> GetMediaByGroup(int groupId, int mediaId = 0)
    {
        var group = await _groupRepository.GetGroupByIdAsync(groupId);
        if (group == null) return BadRequest("Group not found");
        
        return Ok((await _groupRepository.GetMediaByGroupAsync(groupId, mediaId)).Where(m => m.Id > mediaId));
    }
    
    [HttpPost("create")]
    public async Task<ActionResult<int>> CreateGroup(CreateGroupRequest request)
    {
        var owner = _userRepository.GetUserByIdAsync(request.OwnerId).Result;
        if (owner == null) return BadRequest("User not found");

        return Ok(await _groupRepository.CreateGroupAsync(owner, request));
    }

    [HttpPost("add/{groupId}/{userId}")]
    public async Task<ActionResult<SmallGroupInfoResponse>> AddUserToGroup(int groupId, int userId)
    {
        var group = await _groupRepository.GetGroupByIdAsync(groupId);
        if (group == null) return BadRequest("Group not found");

        var user = await _userRepository.GetUserByIdAsync(userId);
        if (user == null) return BadRequest("User not found");

        return Ok(await _groupRepository.AddUserToGroupAsync(group, user));
    }

    [HttpDelete("delete/{groupId}/{userId}")]
    public async Task<ActionResult> DeleteUserFromGroup(int groupId, int userId)
    {
        var group = await _groupRepository.GetGroupByIdAsync(groupId);
        if (group == null) return BadRequest("Group not found");

        var user = await _userRepository.GetUserByIdAsync(userId);
        if (user == null) return BadRequest("User not found");

        await _groupRepository.DeleteUserFromGroupAsync(group, user);
        
        return Ok("removed");
    }

    [HttpDelete("delete/{groupId}")]
    public async Task<ActionResult> DeleteGroup(int groupId)
    {
        var group = await _groupRepository.GetGroupByIdAsync(groupId);
        if (group == null) return BadRequest("Group not found");

        await _groupRepository.DeleteGroupAsync(group);

        return Ok("deleted");
    }
    
    public async Task<Group?> GetGroupById(int groupId)
    {
        return await _groupRepository.GetGroupByIdAsync(groupId);
    }
}