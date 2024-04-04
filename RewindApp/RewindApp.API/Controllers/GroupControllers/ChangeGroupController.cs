using Microsoft.AspNetCore.Mvc;
using RewindApp.Infrastructure.Data;
using RewindApp.Domain.Entities;
using RewindApp.Domain.Requests;
using RewindApp.Domain.Requests.ChangeRequests;
using RewindApp.Infrastructure.Services;

namespace RewindApp.Controllers.GroupControllers;

[ApiController]
[Route("change-group")]
public class ChangeGroupController : ControllerBase
{
    private readonly DataContext _context;
    private readonly IGroupsController _groupsController;
    private readonly SqlService _sqlService;

    public ChangeGroupController(DataContext context)
    {
        _context = context;
        _groupsController = new GroupsController(context);
        _sqlService = new SqlService();
    }

    [HttpPut("name/{groupId}")]
    public async Task<ActionResult<Group>> ChangeName(TextRequest request, int groupId)
    {
        var group = await _groupsController.GetGroupById(groupId);
        if (group == null) return BadRequest("Group not found");

        group.Name = request.Text;
        _context.Groups.Update(group);
        await _context.SaveChangesAsync();
        
        _sqlService.UpdateGroupImage(group);
        
        return Ok(group);
    }
    
    [HttpPut("image/{groupId}")]
    public async Task<ActionResult> ChangeImage(MediaRequest mediaRequest, int groupId)
    {
        var group = await _groupsController.GetGroupById(groupId);
        if (group == null) return BadRequest("Group not found");

        var objectData = Convert.FromBase64String(mediaRequest.Object);
        var tinyObjectData = Convert.FromBase64String(mediaRequest.TinyObject);
        
        group.Image = objectData;
        group.TinyImage = tinyObjectData;
        _context.Groups.Update(group);
        await _context.SaveChangesAsync();
        
        _sqlService.UpdateGroupImage(group);

        return Ok("Image changed");
    }
}