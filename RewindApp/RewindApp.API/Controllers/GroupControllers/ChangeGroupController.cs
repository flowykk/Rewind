using Microsoft.AspNetCore.Mvc;
using RewindApp.Application.Interfaces.GroupInterfaces;
using RewindApp.Infrastructure.Data;
using RewindApp.Domain.Entities;
using RewindApp.Domain.Requests;
using RewindApp.Domain.Requests.ChangeRequests;
using RewindApp.Infrastructure.Data.Repositories.GroupRepositories;
using RewindApp.Infrastructure.Services;

namespace RewindApp.Controllers.GroupControllers;

[ApiController]
[Route("change-group")]
public class ChangeGroupController : ControllerBase
{
    private readonly DataContext _context;
    private readonly IGroupRepository _groupRepository;
    private readonly IChangeGroupRepository _changeGroupRepository;
    private readonly SqlService _sqlService;

    public ChangeGroupController(DataContext context)
    {
        _context = context;
        _groupRepository = new GroupRepository(context);
        _changeGroupRepository = new ChangeGroupRepository(context);
        _sqlService = new SqlService();
    }

    [HttpPut("name/{groupId}")]
    public async Task<ActionResult> ChangeName(int groupId, TextRequest request)
    {
        var group = await _groupRepository.GetGroupByIdAsync(groupId);
        if (group == null) return BadRequest("Group not found");

        await _changeGroupRepository.ChangeName(group, request);
        
        return Ok("Name changed");
    }
    
    [HttpPut("image/{groupId}")]
    public async Task<ActionResult> ChangeImage(int groupId, MediaRequest mediaRequest)
    {
        var group = await _groupRepository.GetGroupByIdAsync(groupId);
        if (group == null) return BadRequest("Group not found");

        await _changeGroupRepository.ChangeImage(group, mediaRequest);

        return Ok("Image changed");
    }
}