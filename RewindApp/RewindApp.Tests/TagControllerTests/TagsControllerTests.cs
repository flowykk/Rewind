using Microsoft.AspNetCore.Mvc;
using RewindApp.Controllers.GroupControllers;
using RewindApp.Controllers.MediaControllers;
using RewindApp.Controllers.TagControllers;
using RewindApp.Controllers.UserControllers;
using RewindApp.Domain.Entities;
using RewindApp.Infrastructure.Data;

namespace RewindApp.Tests.TagControllerTests;

public class TagsControllerTests
{
    private readonly DataContext _context = ContextGenerator.Generate();
    private readonly RegisterController _registerController;
    private readonly GroupsController _groupsController;
    private readonly MediaController _mediaController;
    private readonly TagsController _tagsController;
    private readonly UsersController _usersController;
    
    public TagsControllerTests()
    {
        _registerController = new RegisterController(_context);
        _groupsController = new GroupsController(_context);
        _mediaController = new MediaController(_context);
        _tagsController = new TagsController(_context);
        _usersController = new UsersController(_context);
    }
    
    [Fact]
    public async void ItShould_successfully_add_tag_to_media_by_mediaId()
    {
        // Arrange
        await LoadMedia();
        
        // Assert
        var actionResult = await _tagsController.AddTags(ContextHelper.BuildDefaultTagsRequest(), 1); 
        var result = actionResult.Result as ObjectResult;
        var media = await _mediaController.GetMediaById(1);
        
        // Act
        Assert.Equal("200", result?.StatusCode.ToString());
        Assert.NotEmpty(_context.Tags);
        Assert.NotEmpty(media.Tags);
    }
    
    [Fact]
    public async void ItShould_fail_to_add_tag_to_media_with_invalid_mediaId()
    {
        // Arrange
        await LoadMedia();
        
        // Assert
        var actionResult = await _tagsController.AddTags(ContextHelper.BuildDefaultTagsRequest(), 2); 
        var result = actionResult.Result as ObjectResult;
        
        // Act
        Assert.Equal("400", result?.StatusCode.ToString());
        Assert.Equal("Media not found", result?.Value);
    }
    
    [Fact]
    public async void ItShould_successfully_get_tags()
    {
        // Arrange
        await LoadMedia();
        await _tagsController.AddTags(ContextHelper.BuildDefaultTagsRequest(), 1);
        
        // Act
        var actionResult = await _tagsController.GetTags();
        
        // Assert
        Assert.NotEmpty(actionResult);
        Assert.NotEmpty(_context.Tags);
    }

    [Fact]
    public async void ItShould_successfully_get_tags_by_mediaId()
    {
        // Arrange
        await LoadMedia();
        await _tagsController.AddTags(ContextHelper.BuildDefaultTagsRequest(), 1);

        // Assert
        var actionResult = await _tagsController.GetTagsByMediaId(1);
        var result = actionResult.Result as ObjectResult;
        var value = result?.Value as IEnumerable<Tag>;

        // Act
        Assert.NotNull(value);
        Assert.NotEmpty(value);
    }
    
    [Fact]
    public async void ItShould_successfully_delete_tag_by_mediaId()
    {
        // Arrange
        await LoadMedia();
        await _tagsController.AddTags(ContextHelper.BuildDefaultTagsRequest(), 1);
        
        // Assert
        var actionResult = await _tagsController.DeleteTag(ContextHelper.BuildDefaultTagTextRequest(), 1);
        var result = actionResult as ObjectResult;
        var media = await _mediaController.GetMediaById(1);
        
        // Act
        Assert.Equal("200", result?.StatusCode.ToString());
        Assert.Empty(_context.Tags);
        Assert.Empty(media.Tags);
    }
    
    [Fact]
    public async void ItShould_fail_to_delete_tag_with_invalid_mediaId()
    {
        // Arrange
        await LoadMedia();
        await _tagsController.AddTags(ContextHelper.BuildDefaultTagsRequest(), 1);
        
        // Assert
        var actionResult = await _tagsController.DeleteTag(ContextHelper.BuildDefaultTagTextRequest(), 2);
        var result = actionResult as ObjectResult;
        
        // Act
        Assert.Equal("400", result?.StatusCode.ToString());
        Assert.Equal("Media not found", result?.Value);
        Assert.NotEmpty(_context.Tags);
    }
    
    private async Task LoadMedia()
    {
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());

        var user = await _usersController.GetUserById(1);
        var group = await _groupsController.GetGroupById(1);
        
        await ContextHelper.LoadMedia(ContextHelper.BuildLoadMediaRequest(), _context, group!, user!);
    }
}