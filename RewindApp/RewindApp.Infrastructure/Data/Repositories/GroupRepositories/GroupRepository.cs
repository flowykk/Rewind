using Microsoft.EntityFrameworkCore;
using RewindApp.Application.Extensions;
using RewindApp.Application.Interfaces.GroupInterfaces;
using RewindApp.Application.Interfaces.UserInterfaces;
using RewindApp.Domain.Entities;
using RewindApp.Domain.Requests;
using RewindApp.Domain.Responses;
using RewindApp.Domain.Views;
using RewindApp.Domain.Views.GroupViews;
using RewindApp.Domain.Views.MediaViews;
using RewindApp.Infrastructure.Data.Repositories.UserRepositories;

namespace RewindApp.Infrastructure.Data.Repositories.GroupRepositories;

public class GroupRepository : IGroupRepository
{
    private readonly DataContext _context;
    private readonly IUserRepository _userRepository;

    public GroupRepository(DataContext context)
    {
        _context = context;
        _userRepository = new UserRepository(context);
    }

    public async Task<IEnumerable<Group>> GetGroupsAsync()
    {
        return await _context.Groups.ToListAsync();
    }

    public async Task<BigMediaInfoResponse?> GetRandomMediaAsync(int groupId, int userId, bool images, bool quotes, bool onlyFavorites)
    {
        var filter = new FilterSettings {
            Images = images,
            Quotes = quotes,
            OnlyFavorites = onlyFavorites
        };
        
        return await GetRandomBigMediaAsync(filter, groupId, userId);
    }

    public async Task<GroupInfoResponse?> GetGroupInfoAsync(Group group, int userId, int dataSize)
    {
        var owner = await _userRepository.GetUserByIdAsync(group.OwnerId);
        if (owner == null) return null;
        
        var firstMembers = (await GetUserViewsByGroupAsync(group.Id))
            .Select(u => new UserView {
                Id = u.Id,
                UserName = u.UserName,
                TinyProfileImage = u.TinyProfileImage
            })
            .Where(u => u.Id != owner.Id && u.Id != userId)
            .Shuffle()
            .Take(dataSize);
        
        var firstMedia = (await GetMediaByGroupAsync(group.Id))
            .Shuffle()
            .Take(dataSize);
        
        var resultResponse = new GroupInfoResponse {
            Id = group.Id,
            DataSize = dataSize,
            Name = group.Name,
            Image = group.Image,
            Owner = new UserView {
                Id = owner.Id,
                TinyProfileImage = owner.TinyProfileImage,
                UserName = owner.UserName
            },
            FirstMedia = firstMedia,
            GallerySize = group.Media.Count,
            FirstMembers = firstMembers
        };

        return resultResponse;
    }

    public SmallGroupInfoResponse GetSmallGroupInfo(Group group)
    {
        return new SmallGroupInfoResponse
        {
            Id = group.Id,
            Name = group.Name,
            OwnerId = group.OwnerId,
            TinyImage = group.TinyImage
        };
    }

    public async Task<RewindScreenDataResponse> GetInitialRewindScreenDataAsync(int groupId, int userId)
    {
        var group = await GetGroupByIdAsync(groupId);
        
        var groups = (await GetGroupsByUserAsync(userId))
            .Select(g => new GroupView
            {
                Id = g.Id,
                Name = g.Name,
                OwnerId = g.OwnerId,
                TinyImage = g.TinyImage,
                GallerySize = GetMediaByGroupAsync(g.Id).Result.Count()
            });
        
        var resultResponse = new RewindScreenDataResponse {
            Groups = groups,
            RandomImage = await GetRandomBigMediaAsync(new FilterSettings(), groupId, userId),
            GallerySize = group != null ? group.Media.Count : 0
        };

        return resultResponse;
    }

    public async Task<IEnumerable<GroupView>> GetGroupViewsByUserAsync(int userId)
    {
        return (await GetGroupsByUserAsync(userId))
            .Select(g => new GroupView
            {
                Id = g.Id,
                Name = g.Name,
                OwnerId = g.OwnerId,
                TinyImage = g.TinyImage,
                GallerySize = GetMediaByGroupAsync(g.Id).Result.Count()
            });
    }

    public async Task<IEnumerable<Group>> GetGroupsByUserAsync(int userId)
    {
        return await _context.Users
            .Include(user => user.Groups)
            .Where(user => user.Id == userId)
            .SelectMany(user => user.Groups)
            .ToListAsync();
    }

    public async Task<IEnumerable<UserView>> GetUserViewsByGroupAsync(int groupId)
    {
        return await _context.Groups
            .Include(group => group.Users)
            .Where(group => group.Id == groupId)
            .SelectMany(group => group.Users)
            .Select(u => new UserView {
                Id = u.Id,
                UserName = u.UserName,
                TinyProfileImage = u.TinyProfileImage
            })
            .ToListAsync();
    }
    
    public async Task<IEnumerable<User>> GetUsersByGroupAsync(int groupId)
    {
        return await _context.Groups
            .Include(group => group.Users)
            .Where(group => group.Id == groupId)
            .SelectMany(group => group.Users)
            .ToListAsync();
    }

    public async Task<IEnumerable<MediaView>> GetMediaByGroupAsync(int groupId, int mediaId = 0)
    {
        return await _context.Groups
            .Include(g => g.Media)
            .Where(g => g.Id == groupId)
            .SelectMany(g => g.Media)
            .Select(m => new MediaView {
                Id = m.Id,
                TinyObject = m.TinyObject
            })
            .Where(m => m.Id > mediaId)
            .ToListAsync();
    }

    public async Task<int> CreateGroupAsync(User owner, CreateGroupRequest request)
    {
        var group = new Group
        {
            OwnerId = owner.Id,
            Name = request.GroupName,
            Image = Array.Empty<byte>()
        };
        
        group.Users.Add(owner);
        owner.Groups.Add(group);
        _context.Groups.Add(group);
        await _context.SaveChangesAsync();

        return group.Id;
    }

    public async Task<SmallGroupInfoResponse> AddUserToGroupAsync(Group group, User user)
    {
        var resultResponse = GetSmallGroupInfo(group);

        if ((await GetUsersByGroupAsync(group.Id)).ToList().Contains(user)) 
            return resultResponse;
        
        group.Users.Add(user);
        user.Groups.Add(group);
        await _context.SaveChangesAsync();

        return resultResponse;
    }

    public async Task DeleteUserFromGroupAsync(Group group, User user)
    {
        user.Groups.Remove(group);
        group.Users.Remove(user);
        await _context.SaveChangesAsync();
    }

    public async Task DeleteGroupAsync(Group group)
    {
        _context.Groups.Remove(group);
        await _context.SaveChangesAsync();
    }

    public async Task<Group?> GetGroupByIdAsync(int groupId)
    {
        return await _context.Groups
            .Include(group => group.Media)
            .Include(group => group.Users)
            .FirstOrDefaultAsync(g => g.Id == groupId);
    }

    public async Task<IEnumerable<BigMediaInfoResponse>> GetBigMediaByGroupAsync(FilterSettings filterSettings, int groupId, int userId)
    {
        return await _context.Groups
            .Include(g => g.Media)
            .Where(g => g.Id == groupId)
            .SelectMany(g => g.Media)
            .Where(m => m.Author != null && ((m.IsPhoto && filterSettings.Images) || (!m.IsPhoto && filterSettings.Quotes)))
            .Where(m => !filterSettings.OnlyFavorites || 
                        filterSettings.OnlyFavorites && _userRepository.GetLikedMediaByUser(userId).Result.Contains(m))
            .Select(m => new BigMediaInfoResponse {
                Id = m.Id,
                Object = m.Object,
                Author = new UserView {
                    Id = m.Author!.Id,
                    TinyProfileImage = m.Author.TinyProfileImage,
                    UserName = m.Author.UserName
                },
                Date = m.Date,
                Liked = _userRepository.GetLikedMediaByUser(userId).Result.Contains(m)
            })
            .ToListAsync();
    }

    public async Task<BigMediaInfoResponse?> GetRandomBigMediaAsync(FilterSettings filterSettings, int groupId, int userId)
    {
        var media = (await GetBigMediaByGroupAsync(filterSettings, groupId, userId)).ToList();
        return media.Count == 0 ? null : media[new Random().Next(0, media.Count)];
    }
}