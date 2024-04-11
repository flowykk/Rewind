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

    public async Task AddTagAsync(Media media, string text)
    {
        var tag = new Tag()
        {
            Text = text,
            Media = media
        };
        
        if (GetTagByMedia(media, tag.Text))
            _context.Tags.Add(tag); 

        await _context.SaveChangesAsync();
    }

    public async Task DeleteTagAsync(Media media, Tag tag)
    {
        _context.Tags.Remove(tag);
        media.Tags.Remove(tag);
        await _context.SaveChangesAsync();
    }

    private bool GetTagByMedia(Media media, string text)
    {
        return media.Tags.ToList().FirstOrDefault(t => t.Text == text) == null; 
    }
}