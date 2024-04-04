using Microsoft.EntityFrameworkCore;
using RewindApp.Domain.Entities;
using RewindApp.Application.Interfaces;

namespace RewindApp.Infrastructure.Data.Repositories;

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

        if (media.Tags.ToList().FirstOrDefault(t => t.Text == text) != null)
            return tag;

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