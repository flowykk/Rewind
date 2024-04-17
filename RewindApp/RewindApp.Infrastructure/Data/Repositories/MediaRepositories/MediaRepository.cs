using Microsoft.EntityFrameworkCore;
using RewindApp.Application.Interfaces;
using RewindApp.Application.Interfaces.GroupInterfaces;
using RewindApp.Application.Interfaces.MediaInterfaces;
using RewindApp.Application.Interfaces.UserInterfaces;
using RewindApp.Domain.Entities;
using RewindApp.Domain.Requests.MediaRequests;
using RewindApp.Domain.Views.MediaViews;
using RewindApp.Infrastructure.Data.Repositories.GroupRepositories;
using RewindApp.Infrastructure.Data.Repositories.UserRepositories;
using RewindApp.Infrastructure.Services;

namespace RewindApp.Infrastructure.Data.Repositories.MediaRepositories;

public class MediaRepository : IMediaRepository
{
    private readonly DataContext _context;
    private readonly IUserRepository _userRepository;
    private readonly ITagsRepository _tagsRepository;
    private readonly SqlService _sqlService;

    public MediaRepository(DataContext context)
    {
        _context = context;
        _userRepository = new UserRepository(context);
        _tagsRepository = new TagsRepository(context);
        _sqlService = new SqlService();
    }
    
    public async Task<IEnumerable<Media>> GetMediaAsync()
    {
        return await _context.Media.ToListAsync();
    }

    public async Task<Media?> GetMediaByIdAsync(int mediaId)
    {
        return await _context.Media
            .Include(m => m.Users)
            .Include(m => m.Author)
            .Include(m => m.Tags)
            .FirstOrDefaultAsync(media => media.Id == mediaId);
    }

    public async Task<LargeMediaInfoResponse> GetMediaInfoByIdAsync(Media media, int userId)
    {
        return new LargeMediaInfoResponse
        {
            Id = media.Id,
            Author = media.Author,
            Date = media.Date,
            Object = media.Object,
            Liked = (await _userRepository.GetLikedMediaByUser(userId)).Contains(media),
            Tags = media.Tags
        };
    }

    public async Task LikeMediaAsync(Media media, User user)
    {
        user.Media.Add(media);
        media.Users.Add(user);
        await _context.SaveChangesAsync();
    }

    public async Task UnlikeMediaAsync(Media media, User user)
    {
        user.Media.Remove(media);
        media.Users.Remove(user);
        await _context.SaveChangesAsync();
    }

    public async Task<int> LoadMediaToGroupAsync(LoadMediaRequest mediaRequest, int groupId, int authorId)
    {
        var rawData = Convert.FromBase64String(mediaRequest.Object);
        var tinyData = Convert.FromBase64String(mediaRequest.TinyObject);

        var id = _sqlService.LoadMedia(rawData, tinyData, groupId, authorId, mediaRequest.IsPhoto);
        
        foreach (var tag in mediaRequest.Tags)
            await _tagsRepository.AddTagAsync((await GetMediaByIdAsync(id))!, tag);

        return id;
    }

    public async Task UnloadMediaFromGroupAsync(Media media, Group group)
    {
        var author = media.Author == null ? null : await _userRepository.GetUserByIdAsync(media.Author.Id);

        group.Media.Remove(media);
        author?.Media.Remove(media);
        await _context.SaveChangesAsync();
    }
}