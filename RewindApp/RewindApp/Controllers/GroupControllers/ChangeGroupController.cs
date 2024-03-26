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
    private readonly IGroupsController _groupsController;

    public ChangeGroupController(DataContext context)
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

        var objectData = Convert.FromBase64String(mediaRequest.Object);
        var tinyObjectData = Convert.FromBase64String(mediaRequest.TinyObject);

        var connectionString = DataContext.GetDbConnection();
        var connection = new MySqlConnection(connectionString);
        connection.Open();

        var command = new MySqlCommand()
        {
            Connection = connection,
            CommandText = "UPDATE Groups SET Image = @objectData, TinyImage = @tinyObjectData WHERE Id = @groupId;"
        };
        var imageParameter = new MySqlParameter("?objectData", MySqlDbType.Blob, objectData.Length)
        {
            Value = objectData
        };
        var tinyImageParameter = new MySqlParameter("?tinyObjectData", MySqlDbType.TinyBlob, tinyObjectData.Length)
        {
            Value = tinyObjectData
        };
        var groupIdParameter = new MySqlParameter("?groupId", MySqlDbType.Int64)
        {
            Value = groupId
        };
        
        group.Image = objectData;
        _context.Groups.Update(group);
        await _context.SaveChangesAsync();
        
        command.Parameters.Add(imageParameter);
        command.Parameters.Add(tinyImageParameter);
        command.Parameters.Add(groupIdParameter);
        command.ExecuteNonQuery();

        return Ok("Image changed");
    }
}