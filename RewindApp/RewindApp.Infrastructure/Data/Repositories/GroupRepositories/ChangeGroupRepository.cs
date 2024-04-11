using RewindApp.Application.Interfaces.GroupInterfaces;
using RewindApp.Domain.Entities;
using RewindApp.Domain.Requests;
using RewindApp.Domain.Requests.ChangeRequests;
using RewindApp.Infrastructure.Services;

namespace RewindApp.Infrastructure.Data.Repositories.GroupRepositories;

public class ChangeGroupRepository : IChangeGroupRepository
{
    private readonly DataContext _context;
    private readonly SqlService _sqlService;

    public ChangeGroupRepository(DataContext context)
    {
        _context = context;
        _sqlService = new SqlService();
    }
    
    public async Task ChangeName(Group group, TextRequest request)
    {
        group.Name = request.Text;
        _context.Groups.Update(group);
        await _context.SaveChangesAsync();
        
        _sqlService.UpdateGroupImage(group);
    }

    public async Task ChangeImage(Group group, MediaRequest mediaRequest)
    {
        var objectData = Convert.FromBase64String(mediaRequest.Object);
        var tinyObjectData = Convert.FromBase64String(mediaRequest.TinyObject);
        
        group.Image = objectData;
        group.TinyImage = tinyObjectData;
        _context.Groups.Update(group);
        await _context.SaveChangesAsync();
        
        _sqlService.UpdateGroupImage(group);
    }
}