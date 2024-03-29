using RewindApp.Entities;
using RewindApp.Requests.ChangeRequests;

namespace RewindApp.Interfaces;

public interface ITagsRepository
{
    public Task<IEnumerable<Tag>> GetTagsAsync();
    public IEnumerable<Tag> GetTagsByMediaAsync(Media? media);
    public Task<Tag> AddTagAsync(Media media, string text);
    public Task DeleteTagAsync(Media media, Tag tag);
}