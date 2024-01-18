using System.Text.RegularExpressions;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RewindApp.Data;
using RewindApp.Models;
using RewindApp.Models.RequestsModels;

namespace RewindApp.Controllers;

[ApiController]
[Route("[controller]")]
public class GroupsController : ControllerBase
{
    private readonly DataContext _context;
    private readonly ILogger<GroupsController> _logger;

    public GroupsController(DataContext context, ILogger<GroupsController> logger)
    {
        _context = context;
        _logger = logger;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<Groups>>> GetGroups()   
    {
        return await _context.Groups.ToListAsync();
    }
    
    [HttpPost("create-group")]
    public async Task<ActionResult<IEnumerable<Groups>>> Register(CreateGroupRequest request)
    {
        if (_context.Groups.Any(group => group.GroupOwnerEmail == request.GroupOwnerEmail))
        {
            return BadRequest($"Group with this name, created by User {request.GroupOwnerEmail} already exists!");
        }
        
        var group = new Groups
        { 
            GroupOwnerEmail = request.GroupOwnerEmail,
            GroupName = request.GroupName,
            GroupImage = Array.Empty<byte>()
        };

        _context.Groups.Add(group);
        await _context.SaveChangesAsync();

        return Ok("Group created successfully!");
    }
}