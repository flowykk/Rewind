using Microsoft.AspNetCore.Mvc;
using MySql.Data.MySqlClient;
using RewindApp.Data;
using RewindApp.Requests;
using RewindApp.Requests.ChangeRequests;

namespace RewindApp.Controllers.GroupControllers;

[ApiController]
[Route("change-group")]
public class ChangeGroupController : ControllerBase
{
    private readonly DataContext _context;
   // private readonly ILogger<ChangeGroupController> _logger;
    private readonly IGroupsController _groupsController;

    public ChangeGroupController(DataContext context) //, ILogger<ChangeGroupController> logger, IGroupsController groupsController)
    {
        _context = context;
        _groupsController = new GroupsController(context);
    }

    [HttpPut("name/{groupId}")]
    public async Task<ActionResult> ChangeName(int groupId, NameRequest request)
    {
        var group = await _groupsController.GetGroupById(groupId);
        if (group == null) return BadRequest("Group not found");

        group.Name = request.Name;
        _context.Groups.Update(group);
        await _context.SaveChangesAsync();

        return Ok("Name changed");
    }
    
    [HttpPut("image/{groupId}")]
    public async Task<ActionResult> ChangeGroupImage(MediaRequest mediaRequest, int groupId)
    {
        var group = await _groupsController.GetGroupById(groupId);
        if (group == null) return BadRequest("Group not found");

        var rawData = Convert.FromBase64String(mediaRequest.Media);

        var connectionString = DataContext.GetDbConnection();
        var connection = new MySqlConnection(connectionString);
        connection.Open();

        var command = new MySqlCommand()
        {
            Connection = connection,
            CommandText = "UPDATE Groups SET Image = @rawData WHERE Id = @groupId;"
        };
        var fileContentParameter = new MySqlParameter("?rawData", MySqlDbType.Blob, rawData.Length)
        {
            Value = rawData
        };
        var groupIdParameter = new MySqlParameter("?groupId", MySqlDbType.Int64)
        {
            Value = groupId
        };
        
        command.Parameters.Add(fileContentParameter);
        command.Parameters.Add(groupIdParameter);
        command.ExecuteNonQuery();
        
        group.Image = rawData;
        _context.Groups.Update(group);
        await _context.SaveChangesAsync();

        return Ok("Image changed");
    }
}