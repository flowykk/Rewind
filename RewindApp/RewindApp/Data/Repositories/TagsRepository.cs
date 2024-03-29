using Microsoft.EntityFrameworkCore;
using RewindApp.Controllers.MediaControllers;
using RewindApp.Entities;
using RewindApp.Interfaces;
using RewindApp.Requests.ChangeRequests;

namespace RewindApp.Data.Repositories;

public class TagsRepository : ITagsRepository
{
    private readonly DataContext _context;

    public TagsRepository(DataContext context)
    {
        _context = context;
    }
    
    public async Task<IEnumerable<Tag>> GetTagsAsync()
    {
        return await _context.Tags.ToListAsync();
    }

    public IEnumerable<Tag> GetTagsByMediaAsync(Media? media)
    {
        return media == null ? new List<Tag>() : media.Tags.ToList();
    }

    public async Task<Tag> AddTagAsync(Media media, string text)
    {
        var tag = new Tag()
        {
            Text = text,
            Media = media
        };

        _context.Tags.Add(tag); 
        await _context.SaveChangesAsync();

        return tag;
    }

    public async Task DeleteTagAsync(Media media, Tag tag)
    {
        _context.Tags.Remove(tag);
        media.Tags.Remove(tag);
        await _context.SaveChangesAsync();
    }
}