using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RewindApp.Controllers.GroupControllers;
using RewindApp.Controllers.UserControllers;
using RewindApp.Data;
using RewindApp.Entities;
using RewindApp.Requests.ChangeRequests;
using RewindApp.RequestsModels;

namespace RewindApp.Controllers.GroupControllers;

[ApiController]
[Route("change-group")]
public class ChangeGroupController : ControllerBase
{
    private readonly DataContext _context;
    private readonly ILogger<ChangeGroupController> _logger;
    private readonly IGroupsController _groupsController;

    public ChangeGroupController(DataContext context, ILogger<ChangeGroupController> logger, IGroupsController groupsController)
    {
        _context = context;
        _logger = logger;
        _groupsController = groupsController;
    }

    [HttpPut("name/{groupId}")]
    public async Task<ActionResult> ChangeName(int groupId, NameRequest request)
    {
        var group = await _groupsController.GetGroupById(groupId);
        if (group == null) return BadRequest("Group not found");

        group.GroupName = request.Name;
        _context.Groups.Update(group);
        await _context.SaveChangesAsync();

        return Ok("Name changed");
    }
}