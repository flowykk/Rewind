using Microsoft.AspNetCore.Mvc;
using MySql.Data.MySqlClient;
using RewindApp.Data;
using RewindApp.Requests;
using RewindApp.Requests.ChangeRequests;
using RewindApp.Services;

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
    public async Task<ActionResult> ChangeName(int groupId, NameRequest request)
    {
        var group = await _groupsController.GetGroupById(groupId);
        if (group == null) return BadRequest("Group not found");

        group.Name = request.Name;
        _context.Groups.Update(group);
        await _context.SaveChangesAsync();
        
        var imageParameter = new MySqlParameter("?objectData", MySqlDbType.Blob, group.Image.Length)
        {
            Value = group.Image
        };
        var tinyImageParameter = new MySqlParameter("?tinyObjectData", MySqlDbType.TinyBlob, group.TinyImage.Length)
        {
            Value = group.TinyImage
        };
        var nameParameter = new MySqlParameter("?name", MySqlDbType.VarChar, request.Name.Length)
        {
            Value = request.Name
        };
        var groupIdParameter = new MySqlParameter("?groupId", MySqlDbType.Int64)
        {
            Value = groupId
        };

        const string commandText = "UPDATE Groups SET Image = @objectData, TinyImage = @tinyObjectData, Name = @name WHERE Id = @groupId;";
        var parameters = new List<MySqlParameter>
        {
            nameParameter,
            imageParameter,
            tinyImageParameter,
            groupIdParameter
        };
        _sqlService.UpdateInfo(commandText, parameters);
        
        return Ok(group);
    }
    
    [HttpPut("image/{groupId}")]
    public async Task<ActionResult> ChangeGroupImage(MediaRequest mediaRequest, int groupId)
    {
        var group = await _groupsController.GetGroupById(groupId);
        if (group == null) return BadRequest("Group not found");

        var objectData = Convert.FromBase64String(mediaRequest.Object);
        var tinyObjectData = Convert.FromBase64String(mediaRequest.TinyObject);
        
        group.Image = objectData;
        _context.Groups.Update(group);
        await _context.SaveChangesAsync();
        
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

        const string commandText = "UPDATE Groups SET Image = @objectData, TinyImage = @tinyObjectData WHERE Id = @groupId;";
        var parameters = new List<MySqlParameter>
        {
            imageParameter,
            tinyImageParameter,
            groupIdParameter
        };
        _sqlService.UpdateInfo(commandText, parameters);

        return Ok("Image changed");
    }
}