using Microsoft.AspNetCore.Mvc;
using RewindApp.Controllers.GroupControllers;
using RewindApp.Controllers.MediaControllers;
using RewindApp.Controllers.TagControllers;
using RewindApp.Controllers.UserControllers;
using RewindApp.Data;

namespace RewindApp.Tests.TagControllerTests;

public class TagsControllerTests
{
    private readonly DataContext _context = ContextGenerator.Generate();
    private readonly RegisterController _registerController;
    private readonly GroupsController _groupsController;
    private readonly MediaController _mediaController;
    private readonly TagsController _tagsController;
    
    public TagsControllerTests()
    {
        _registerController = new RegisterController(_context);
        _groupsController = new GroupsController(_context);
        _mediaController = new MediaController(_context);
        _tagsController = new TagsController(_context);
    }
    
    [Fact]
    public async void ItShould_successfully_add_tag_to_media_by_mediaId()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        await _mediaController.LoadMediaToGroup(ContextHelper.BuildTestImageRequest(), 1);
        
        // Assert
        var actionResult = await _tagsController.AddTag(ContextHelper.BuildDefaultNameRequest(), 1); 
        var result = actionResult as ObjectResult;
        var media = await _mediaController.GetMediaById(1);
        
        // Act
        Assert.Equal("200", result.StatusCode.ToString());
        Assert.NotEmpty(_context.Tags);
        Assert.NotEmpty(media.Value.Tags);
    }
    
    [Fact]
    public async void ItShould_fail_to_add_tag_to_media_with_invalid_mediaId()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        await _mediaController.LoadMediaToGroup(ContextHelper.BuildTestImageRequest(), 1);
        
        // Assert
        var actionResult = await _tagsController.AddTag(ContextHelper.BuildDefaultNameRequest(), 2); 
        var result = actionResult as ObjectResult;
        
        // Act
        Assert.Equal("400", result.StatusCode.ToString());
        Assert.Equal("Media not found", result.Value);
    }
    
    [Fact]
    public async void ItShould_fail_to_add_duplicate_tag_to_media_by_mediaId()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        await _mediaController.LoadMediaToGroup(ContextHelper.BuildTestImageRequest(), 1);
        await _tagsController.AddTag(ContextHelper.BuildNameRequest("test"), 1);
        
        // Assert
        var actionResult = await _tagsController.AddTag(ContextHelper.BuildNameRequest("test"), 1); 
        var result = actionResult as ObjectResult;
        
        // Act
        Assert.Equal("400", result.StatusCode.ToString());
        Assert.Equal("Media already has such Tag", result.Value);
    }
    
    [Fact]
    public async void ItShould_successfully_get_tags()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        await _mediaController.LoadMediaToGroup(ContextHelper.BuildTestImageRequest(), 1);
        await _tagsController.AddTag(ContextHelper.BuildDefaultNameRequest(), 1);
        
        // Act
        var actionResult = await _tagsController.GetTags();
        
        // Assert
        Assert.NotEmpty(actionResult);
        Assert.NotEmpty(_context.Tags);
    }

    [Fact]
    public async void ItShould_successfully_get_media_tags_by_mediaId()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        await _mediaController.LoadMediaToGroup(ContextHelper.BuildTestImageRequest(), 1);
        await _tagsController.AddTag(ContextHelper.BuildDefaultNameRequest(), 1);

        // Assert
        var actionResult = await _tagsController.GetTagsByMediaId(1);
        var media = await _mediaController.GetMediaById(1);

        // Act
        Assert.NotNull(actionResult.Value);
        Assert.NotEmpty(media.Value.Tags);
    }

    [Fact] public async void ItShould_fail_to_get_media_tags_with_invalid_mediaId()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        await _groupsController.CreateGroup(ContextHelper.BuildTestCreateGroupRequest());
        await _mediaController.LoadMediaToGroup(ContextHelper.BuildTestImageRequest(), 1);
        await _tagsController.AddTag(ContextHelper.BuildDefaultNameRequest(), 1);

        // Assert
        var actionResult = await _tagsController.GetTagsByMediaId(2);
        var result = actionResult.Result as ObjectResult;
        
        // Act
        Assert.Equal("400", result.StatusCode.ToString());
        Assert.Equal("Media not found", result.Value);
    }
}